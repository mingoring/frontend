POST /api/v1/lessons

<aside>

**[API 설명]**

- 사용자가 입력한 YouTube 영상 링크로 새 lesson 생성을 요청한다.
- URL 자체에 대한 1차 String 유효성 검증은 클라이언트에서 처리한다.
    - UI 규칙: 실패 시 `Invalid link!` 표기
- 본 API 는 라이브러리 메인 화면 > + 버튼 > Create Learning 버튼 클릭 시점에 호출한다.
- 본 API의 성공 응답은 “생성 완료”가 아니라, “생성 요청 접수(요청을 정상 처리)”를 의미한다. (실제 생성 로직은 서버에서 비동기 작업으로 진행된다.)
- 서버 규칙
    - 사용자가 입력한 **YouTube 영상 URL이 “학습 생성 가능한 링크인지”** 2차로 사전 검증한다.
        - **Korean video만 지원**
        - **YouTube Shorts 링크는 지원하지 않음**
    - 이후 생성 요청을 시작한다.
    - 주의할 점은 아래 두 케이스 모두 지원해야 한다.
        - lesson이 이미 DB에 존재하지 않으면: lesson 생성 + 생성된 lesson 을 user의 Library에 추가
        - lesson이 이미 DB에 존재하면: 존재하는 lesson 을 user의 Library에 추가
- LibraryException (프론트에서 아래 코드일 경우에는 메세지 보여줌)
    
    
    | 상태숫자 | code | 설명 |
    | --- | --- | --- |
    | 400 | INVALID_REQUEST | 잘못된 요청 형식 |
    | 400 | SHORTS_NOT_SUPPORTED | YouTube Shorts는 지원하지 않음 |
    | 400 | VIDEO_NOT_FOUND | 영상을 찾을 수 없음 |
    | 400 | VIDEO_PRIVATE | 비공개 영상임 |
    | 400 | REGION_RESTRICTED | 지역 제한이 걸린 영상임 |
    | 400 | LANGUAGE_NOT_SUPPORTED | 지원하지 않는 언어의 영상임 |
    | 400 | INVALID_URL | 유효하지 않은 URL임 |
    | 400 | NOT_YOUTUBE | YouTube URL이 아님 |
    | 402 | INSUFFICIENT_CREDIT | 크레딧이 부족함 |
    | 409 | LESSON_ALREADY_EXISTS | 이미 추가된 영상/레슨임 |
</aside>

## Request

**Header**

```
Authorization: Bearer <token>
```

**Query**

없음

**Body**

```jsx
{
  "sourceType": "YOUTUBE",
  "url": "https://youtu.be/abc123"
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | sourceType | 소스 타입 (고정: YOUTUBE) | N |
| String | url | YouTube 영상 URL (Shorts 불가) | N |

## **Response** `202` Accepted

No Content

## Error Response `402` : 크레딧 부족

- 유저의 남은 크레딧이 부족해서 더 이상 lesson 생성 요청을 받을 수 없음

```json
{
  "status": 402,
  "code": "INSUFFICIENT_CREDIT",
  "message": "잔여 크레딧이 부족합니다."
}
```

## Error Response `400` : 링크 정책 위반(Shorts/비한국어 등)

```json
{
  "status": 400,
  "code": "INVALID_REQUEST",
  "message": "잘못된 요청 형식입니다."
}
```

```json
{
  "status": 400,
  "code": "SHORTS_NOT_SUPPORTED",
  "message": "YouTube Shorts 링크는 지원되지 않습니다."
}
```

```json
{
  "status": 400,
  "code": "VIDEO_NOT_FOUND",
  "message": "영상을 찾을 수 없습니다."
}
```

```json
{
  "status": 400,
  "code": "VIDEO_PRIVATE",
  "message": "비공개 영상입니다."
}
```

```json
{
  "status": 400,
  "code": "REGION_RESTRICTED",
  "message": "지역 제한이 걸린 영상입니다."
}
```

```json
{
  "status": 400,
  "code": "LANGUAGE_NOT_SUPPORTED",
  "message": "지원하지 않는 언어의 영상입니다."
}
```

```json
{
  "status": 400,
  "code": "INVALID_URL",
  "message": "유효하지 않은 URL입니다."
}
```

```json
{
  "status": 400,
  "code": "NOT_YOUTUBE",
  "message": "YouTube URL이 아닙니다."
}
```

## Error Response `409` : 중복 생성

- 동일 사용자 기준 동일 videoId로 이미 lesson이 존재 (lesson 자체가 Library에 존재한다는 의미)

```json
{
  "code": "LESSON_ALREADY_EXISTS",
  "message": "해당 영상으로 이미 레슨이 존재합니다. (existingLessonId=20483715)"
}
```
