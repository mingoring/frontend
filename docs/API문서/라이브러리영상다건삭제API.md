DELETE /api/v1/lessons


<aside>

[API 설명]

- 로그인한 유저가 **라이브러리 화면에서 선택한 특정 레슨(영상)들만** 골라 **라이브러리에서 삭제**한다.
- 클라이언트는 UI에서 선택된 `lessonIds`만 모아 전달하고, 서버는 해당 레슨들을 유저의 라이브러리에서 제거(삭제)한다.
- 정책
    - **부분 성공 없이 전체 실패**: `lessonIds` 중 하나라도 유효하지 않으면 전체 요청 실패
    - **삭제는 “유저의 라이브러리에서 제거” 의미**(원본 레슨 자체를 DB에서 삭제하는 개념이 아님)
    - 최소 1개 이상 선택 필수
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
  "lessonIds": [123436541, 123436542, 123436543]
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| List(Long) | lessonIds | 삭제할 레슨 ID 목록 (최소 1개) | N |

## Response `204`

No contents

## Error Response `400` : 잘못된 요청

- 발생 케이스
    - `lessonIds` 누락 또는 형식 오류

```json
{
  "code": "INVALID_REQUEST",
  "message": "lessonIds는 비어 있지 않은 배열이어야 합니다."
}
```

## Error Response `403` : 변경 권한 없음(타 유저 소유 등)

- 발생 케이스
    - `lessonIds` 중 사용자가 접근 권한이 없는 레슨이 포함

```json
{
  "code": "FORBIDDEN",
  "message": "하나 이상의 레슨에 대한 삭제 권한이 없습니다."
}
```

## Error Response `404` : 레슨을 찾을 수 없음

- 발생 케이스
    - `lessonIds` 중 하나라도 존재하지 않거나, 해당 유저 라이브러리에 없는 레슨이 포함
    - **정책: 부분 성공 없이 전체 실패**

```json
{
  "code": "LESSON_NOT_FOUND",
  "message": "라이브러리에서 하나 이상의 레슨을 찾을 수 없습니다. (NotFoundLessonIds: 123436999)"
}
```