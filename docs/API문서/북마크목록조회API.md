GET /api/v1/bookmarks

<aside>
API 설명

- 로그인한 사용자의 **북마크 목록**을 조회한다.
    - BookmarkScreen 진입 시점: 따로 `keyword` 쿼리없이 API 요청 바로 보내기
    - 검색: 모바일 키보드 상에서 엔터 누르는 시점에 `keyword` 쿼리 포함해 API 요청
- 북마크 카드 UI에서 필요한 정보를 내려준다.
    - `originalText`: 한국어
    - `translatedText`: 영어
    - `lessonId`, `learningCardId`
        - 재생(lesson 이동) 버튼을 누르면 특정 `lessonId`에 매핑되는 `learningCardId`로 연결되어야 한다.
- Query
    - 정렬: `Newest` / `Oldest` 지원 → 프론트에서 sort 쿼리로 선택해서 요청 (기본값`NEWEST`)
        - `sort=NEWEST`: `bookmarkedAt`기준 내림차순(최신이 위) → 백엔드 응답 기준
        - `sort=OLDEST`: `bookmarkedAt`기준 오름차순(과거가 위) → 백엔드 응답 기준
    - 키워드 검색: `keyword` 검색
- TTS 재생 버튼은 클라이언트에서 처리하므로, 서버는 TTS용 텍스트(`originalText`)만 제공하면 된다.
- 시간 필드(`bookmarkedAt`)는 API 요청/응답 및 서버/DB에서는 모두 UTC 기준으로 저장 및 처리된다. 만약 해당 시간 필드를 UI에 표시해야하는 경우가 생기면 클라이언트는 유저의 타임존을 확인하여 UI에는 UTC에서 유저 타임존 기준으로 변환하여 표시한다.
</aside>

## Request

**Header**

```
Authorization: Bearer <token>
```

**Query**
| 타입 | 필드명 | 설명 | nullable | 기본값 |
| --- | --- | --- | --- | --- |
| String | sort | 정렬 기준 (`NEWEST`, `OLDEST`) | Y | `NEWEST` |
| String | keyword | 검색어(원문/번역 대상으로 부분 일치 검색) 
→ 포함되는 것 전부 응답, 빈값 보내면 리스트 전부 반환 | Y | - |
| int | page | 1부터 시작하는 페이지 번호 | Y | 1 |
| int | size | 페이지 크기 (1~50) | Y | 20 |

**Body**

없음

## Response `200`

```json
{
  "items": [
    {
      "bookmarkId": 123,
      "originalText": "정말 보고 싶었어요.",
      "translatedText": "I really missed you.",
      "lessonId": 45,
      "learningCardId": 987,
      "bookmarkedAt": "2026-03-04T05:10:12Z"
    },
    {
      "bookmarkId": 122,
      "originalText": "혹시 시간 있으세요?",
      "translatedText": "Do you have time by any chance?",
      "lessonId": 45,
      "learningCardId": 988,
      "bookmarkedAt": "2026-03-03T10:02:01Z"
    }
  ],
  "paging": {
    "page": 1,
    "size": 20,
    "totalItems": 47,
    "totalPages": 3,
    "hasNext": true
  }
}
```
| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| List | items | 북마크 목록 | N |
| Long | items[].bookmarkId | 북마크 고유 id | N |
| String | items[].originalText | 북마크 원문(카드에 표시 + TTS 입력으로 사용) | N |
| String | items[].translatedText | 번역문(카드에 표시) | Y |
| Long | items[].lessonId | 재생 버튼 클릭 시 이동할 레슨 id | N |
| Long | items[].learningCardId | 레슨 내에서 오픈할 러닝카드 id | N |
| String(datetime) | items[].bookmarkedAt | 북마크 생성 시각 (UTC) | N |
| Object | paging | 페이지 정보 | N |
| int | paging.page | 현재 페이지 (1-base) | N |
| int | paging.size | 요청한 페이지 크기 | N |
| int | paging.totalItems | 전체 북마크 수 | N |
| int | paging.totalPages | 전체 페이지 수 | N |
| boolean | paging.hasNext | 다음 페이지 존재 여부 | N |