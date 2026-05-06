GET /api/v1/bookmarks/stats

<aside>
 API 설명

- 로그인한 사용자의 **북마크에 저장된 총 개수**를 조회한다.
</aside>

## Request

**Header**

```
Authorization: Bearer <token>
```

**Query**

없음

**Body**

없음

## Response `200`

```json
{
  "count": 15
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| int | count | 로그인 사용자의 북마크 총 개수 | N |