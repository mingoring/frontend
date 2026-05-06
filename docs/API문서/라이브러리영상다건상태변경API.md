PATCH /api/v1/lessons/status

<aside>

**[API 설명]**

- 로그인한 유저가 **라이브러리 화면에서 선택한 특정 레슨(영상)들만** 골라 **동일한 상태로 일괄 변경**한다.
- 클라이언트는 UI에서 선택된 `lessonIds`만 모아 전달하고, 서버는 해당 레슨들의 상태를 지정한 값으로 설정한다.
- LibraryStatusChangeBottomSheet(UI) 기준으로 **변경 대상 상태는 `IN_PROGRESS`, `COMPLETED`만 제공**한다. (`UPLOADING`은 업로드 진행 상태이므로 수동 변경 불가)
- 변경은 **로그인 사용자 기준**으로만 처리하며, 다른 유저의 레슨/라이브러리에 없는 레슨은 처리할 수 없다.
- 백엔드 처리 가이드
    - completed 로 바꿨다고 해서 progressRatio 이 1이 되는건 아님. progressRatio은 그냥 사용자가 마지막으로 학습한 문장의 위치를 나타내는거임.
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
  "lessonIds": [123436541, 123436542, 123436543],
  "status": "COMPLETED"
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| List(Long) | lessonIds | 상태를 변경할 레슨 ID 목록 (최소 1개) | N |
| String(enum) | status | 변경할 목표 상태 (IN_PROGRESS, COMPLETED) | N |

## Response `204`

No contents

## Error Response `400` : 잘못된 요청

- 발생 케이스
    - `lessonIds` 누락 또는 형식 오류
    - `status` 누락 또는 형식 오류

```json
{
  "code":"INVALID_REQUEST",
  "message": "lessonIds는 비어 있지 않은 배열이어야 하며, status는 IN_PROGRESS 또는 COMPLETED 중 하나여야 합니다."
}
```

## Error Response `403` : 변경 권한 없음(타 유저 소유 등)

- 발생 케이스
    - `lessonIds` 중 사용자가 접근 권한이 없는 레슨이 포함

```json
{
  "code":"FORBIDDEN",
  "message": "하나 이상의 레슨에 대한 변경 권한이 없습니다."
}
```

## Error Response `404` : 레슨을 찾을 수 없음

- 발생 케이스
    - `lessonIds` 중 하나라도 존재하지 않거나, 해당 유저 라이브러리에 없는 레슨이 포함
    - **정책: 부분 성공 없이 전체 실패**

```json
{
  "code":"LESSON_NOT_FOUND",
  "message": "라이브러리에서 하나 이상의 레슨을 찾을 수 없습니다. (NotFoundLessonIds: 123436999)"
}
```
