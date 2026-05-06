GET /api/v1/lessons

<aside>
**[API 설명]**

- **로그인한 유저가 라이브러리에 저장한 레슨 목록**을 조회한다.
- 목록 정렬은 유저가 라이브러리에 추가한 시각(`addedAt`) 기준 최신순(Newest) 만 지원한다.
- 상단 탭( `All` / `Uploading` / `In Progress`/ `Completed` )에 맞춰 **상태별 필터링**을 지원한다.
- 서버는 카드 UI 렌더링에 필요한 정보(썸네일, 제목, 상태 뱃지, 진행률, 재생시간 등)를 제공한다.
- **Status 값 정의**
    | 값 | UI 라벨 | 설명 |
    | --- | --- | --- |
    | `UPLOADING` | Uploading | 업로드 진행 중 |
    | `IN_PROGRESS` | In Progress | 학습 진행 중 |
    | `COMPLETED` | Completed | 학습 완료 |
- `videoTime` 포맷 규칙
    - 형식: **`MM:SS`**
        - `MM`(분): **0 이상의 정수**, 2자리이상 가능
        - `SS`(초): **00~59**, 항상 2자리
    - 1시간 이상도 `HH:MM:SS`로 확장하지 않고 누적 분으로 표현
        - 예: 1시간 2분 3초 → `"62:03"`
</aside>

## Request

**Header**

```
Authorization: Bearer <token>
```

**Query**

```
?status=ALL&page=1&size=20
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | status | 탭 필터 값 단일 선택. ALL이면 전체 조회
(default: ALL) | Y |
| int | page | 1부터 시작하는 페이지 번호
(default: 1) | Y |
| int | size | 페이지 크기 (1~50)
(default: 20, max: 50) | Y |

**Body**

없음

## Response `200`

```json
{
  "items": [
    {
      "lessonId": 12343,
      "status": "IN_PROGRESS",
      "title": "BLACKPINK ROSÉ’s Honest Puzzle Intervie...",
      "thumbnailUrl": "https://cdn.example.com/thumbs/lsn_1a3c0f22.jpg",
      "originalText": "오늘은 재미있게 놀아볼까요?",
      "translatedText": "Let's play fun games today!",
      "progressRatio": 0.35,
      "videoTime": "32:33",
      "addedAt": "2026-03-01T12:01:02Z"
    }
  ],
  "paging": {
    "page": 1,
    "size": 20,
    "totalItems": 73,
    "totalPages": 4,
    "hasNext": true
  }
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| List | items | 레슨(라이브러리 카드) 목록 | N |
| Long | items[].lessonId | 레슨 ID | N |
| String(enum) | items[].status | 레슨 상태 (UPLOADING, IN_PROGRESS, COMPLETED) | N |
| String | items[].title | 카드 메인 제목(표시용) | N |
| String(url) | items[].thumbnailUrl | 썸네일 이미지 URL | Y |
| String | items[].originalText | 원문 텍스트 (한국어) | N |
| String | items[].translatedText | 번역된 텍스트 (영어) | N |
| double | items[].progressRatio | 학습 진행률 소수점 2자리 수(0~1). UPLOADING인 경우 또는 학습하지 않은 경우 null | Y |
| String | items[].videoTime | 레슨 시간(MM:SS) | N |
| String(datetime) | items[].addedAt | 유저가 라이브러리에 추가한 시각 (UTC) | N |
| Object | paging | 페이지 정보 | N |
| int | paging.page | 현재 페이지(1-base) | N |
| int | paging.size | 요청한 페이지 크기 | N |
| int | paging.totalItems | 전체 아이템 수 | N |
| int | paging.totalPages | 전체 페이지 수 | N |
| boolean | paging.hasNext | 다음 페이지 존재 여부 | N |


## Error Response `400` : 잘못된 query 값

- 발생 케이스
    - `status`가 허용 값이 아님
    - `page < 1`
    - `size < 1` 또는 `size > 50`

```json
{
  "code": "INVALID_REQUEST",
  "message": "잘못된 쿼리 파라미터입니다: status."
}
```