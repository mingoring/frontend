학습 캘린더 조회

get /api/v1/calendar



<aside>
API 설명

- 캘린더 화면에서 **RECENT(홈 미니)** / **MONTHLY(지정 월)** 의 “학습한 날짜 리스트”를 조회한다.
- 날짜 기준은 **유저 로컬 시간대 기준**이므로, 클라이언트는 요청 시 유저의 **timezone과 todayDate(로컬 기기 오늘)** 를 반드시 포함해야 한다.
- 서버는 **viewType** 에 따라 조회 범위를 결정하여 다음의 데이터를 반환한다.
    - 범위 표시용: **rangeStart, rangeEnd**
        - RECENT: 최근 N일(기본 4일, todayDate 포함, 월 무관)
        - MONTHLY: 해당 월의 1일~말일
    - 캘린더 표시용: **learnedDates(학습한 날들)** 리스트 (범위 내, 중복 없음, 오름차순)
    - 상단 뱃지용: **streakDays(연속학습일수)** (todayDate 기준으로 계산)
- 조회 범위 결정 규칙
    - `viewType=RECENT`
        - 기준: `todayDate` 포함 **최근 4일**
        - `rangeStart` = `todayDate` - `3 days`
        - `rangeEnd` = `todayDate`
    - `viewType=MONTHLY`
        - 기준 월 = (`targetMonth`가 있으면 그 값, 없으면 `todayDate`의 월)
        - `rangeStart` = `기준 월`의 1일
        - `rangeEnd` = `기준 월`의 말일
- streakDays 계산 규칙 ⇒ 백에서 처리함
    - 예시
        - todayDate=09-25, 09-24/09-23 학습함, 09-25도 학습함
        baseStreak(어제부터)=2 (24,23)
        todayBonus=1 → streakDays=3
        - todayDate=09-25, 09-24/09-23 학습함, 09-25는 학습 안 함
        baseStreak=2, todayBonus=0 → streakDays=2
        - todayDate=09-26, 09-25(어제) 학습 안 함
        baseStreak=0, todayBonus(26 학습 안 함)=0 → streakDays=0
    - `todayDate` 기준으로,
        - `yesterday = todayDate - 1 day`
        - `baseStreak = yesterday부터 과거로 연속 학습한 날짜 수`
        - `todayBonus = (todayDate가 learnedDates/학습기록에 존재하면 1, 아니면 0)`
        - `streakDays = baseStreak + todayBonus`
        
        ```dart
        abstract final class StreakDaysCalculator {
          /// Streak 계산 규칙
          /// 1) baseStreak = 어제부터 과거로 연속 학습일 수
          /// 2) todayBonus = 오늘 학습했으면 1, 아니면 0
          /// 3) 최종 streakDays = baseStreak + todayBonus
          static int calculate({
            required DateTime todayDate,
            required Iterable<DateTime> learnedDates,
          }) {
            final normalizedToday = _normalize(todayDate);
            final normalizedLearnedDates = learnedDates.map(_normalize).toSet();
            final baseStreak = calculateBaseStreak(
              todayDate: normalizedToday,
              learnedDates: normalizedLearnedDates,
            );
            final todayBonus = calculateTodayBonus(
              todayDate: normalizedToday,
              learnedDates: normalizedLearnedDates,
            );
        
            return baseStreak + todayBonus;
          }
        
          static int calculateBaseStreak({
            required DateTime todayDate,
            required Iterable<DateTime> learnedDates,
          }) {
            final normalizedToday = _normalize(todayDate);
            final normalizedLearnedDates = learnedDates.map(_normalize).toSet();
            var count = 0;
            var cursor = normalizedToday.subtract(const Duration(days: 1));
        
            while (normalizedLearnedDates.contains(cursor)) {
              count += 1;
              cursor = cursor.subtract(const Duration(days: 1));
            }
        
            return count;
          }
        
          static int calculateTodayBonus({
            required DateTime todayDate,
            required Iterable<DateTime> learnedDates,
          }) {
            final normalizedToday = _normalize(todayDate);
            final normalizedLearnedDates = learnedDates.map(_normalize).toSet();
            return normalizedLearnedDates.contains(normalizedToday) ? 1 : 0;
          }
        
          static DateTime _normalize(DateTime date) {
            return DateTime(date.year, date.month, date.day);
          }
        }
        
        ```
        
    - 어제가 학습하지 않은 날이면?
        - baseStreak = 0
        - streakDays = 오늘 학습 여부에 따라 0 또는 1.
- 서버 규칙
    
    서버는 학습 이벤트 발생 시점에 **유저 로컬 날짜 단위로 학습 기록을 적재(upsert)** 하는 로직이 이미 구현되어 있어야하고, 본 API는 그 기록을 **요청 viewType에 따라 결정된 range 단위로 조회**한다.
    
    - **적재(upsert) 시**: 학습 이벤트(예: 레슨 시작 버튼 클릭) 발생 → 유저 timezone 기반 `(userId, localDate)` upsert
    - **조회 시**: `(userId, localDate)`를 `rangeStart~rangeEnd`로 조회 → `learnedDates` 반환
</aside>

## Request

**Header**

```
Authorization: Bearer <token>
```

**Query**

```
timezone=<IANA Timezone>
todayDate=<YYYY-MM-DD>
viewType=<RECENT|MONTHLY>
targetMonth=<YYYY-MM>     (optional, monthly only)
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | timezone | 유저 로컬 시간대. 예: Asia/Seoul | N |
| LocalDate | todayDate | 클라이언트가 판단한 “오늘(로컬기기)” 날짜 | N |
| String | viewType | RECENT/MONTHLY | N |
| String | targetMonth | viewType=MONTHLY일 때 타겟 월(YYYY-MM). 미전달 시 todayDate의 월 | Y |

**Body**

없음

## Response `200`

- 서버 처리 규칙: 응답은 viewType과 무관하게 **rangeStart/rangeEnd를 항상 포함**한다.

```json
{
  "viewType": "RECENT",
  "rangeStart": "2026-09-22",
  "rangeEnd": "2026-09-25",
  "streakDays": 3,
  "learnedDates": [
    "2026-09-23",
    "2026-09-24",
    "2026-09-25"
  ]
}
```

```json
{
  "viewType": "MONTHLY",
  "rangeStart": "2026-09-01",
  "rangeEnd": "2026-09-30",
  "streakDays": 3,
  "learnedDates": [
    "2026-09-03",
    "2026-09-07",
    "2026-09-08",
    "2026-09-19",
    "2026-09-23",
    "2026-09-24",
    "2026-09-25"
  ]
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | viewType | RECENT/MONTHLY | N |
| String(date) | rangeStart | 조회 범위 시작일(로컬, YYYY-MM-DD) | N |
| String(date) | rangeEnd | 조회 범위 종료일(로컬, YYYY-MM-DD) | N |
| int | streakDays | 연속 학습 일수 | N |
| List(String(date)) | learnedDates | 조회 범위(rangeStart~rangeEnd) 내 학습한 날짜 리스트 | N |

