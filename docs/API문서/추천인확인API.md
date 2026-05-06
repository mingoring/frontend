온보딩 단계에서 추천인 유효성 확인하는 API
GET /api/v1/credits/rewards/referral/verify

<aside>

**[API 설명]**

- 회원가입 플로우에서 사용자가 입력한 **추천인 코드의 유효성을 즉시 검사**하기 위한 API이다. **(지급 트리거 X)**
- UI 동작
    - 사용자가 추천인 코드를 입력하고 **Verify**를 누르면 호출한다.
    - 유효하면 체크 표시와 **“Code applied!”** 같은 성공 메시지를 노출한다.
    - 유효하지 않으면 에러 메시지를 노출하고 적용(등록) 단계로 진행하지 않는다.
- result 코드
    
    
    | 값 | 의미 |
    | --- | --- |
    | `VALID` | 사용 가능한 추천인 코드 |
    | `INVALID_FORMAT` | 요청한 추천인 코드의 형식이 올바르지 않음 |
    | `REFERRAL_CODE_NOT_FOUND` | 입력한 추천인 코드가 존재하지 않음 |
    | `REFERRAL_CODE_INACTIVE` | 입력한 추천인 코드가 비활성 또는 정지 상태임 |
    | `REFERRAL_CODE_EXPIRED` | 입력한 추천인 코드가 만료됨 |
    | `SELF_REFERRAL_NOT_ALLOWED` | 입력한 추천인 코드가 본인 소유 코드임 |
    | `REFERRAL_ALREADY_APPLIED` | 이미 추천인 코드 적용 이력이 있어 추가 적용 불가 |
</aside>

## Request

**Header**

없음

**Query**

```
/api/v1/credits/rewards/referral/verify?referralCode=FF1295DG
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | referralCode | 검증할 추천인 코드 | N |

**Body**

없음

## Response `200`

- 유효
    
    ```json
    {
      "result": "VALID"
    }
    ```
    
- 무효
    
    ```json
    {
      "result": "REFERRAL_CODE_NOT_FOUND"
    }
    ```
    

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| String | result | 추천인 코드가 유효성 검증 결과 (`VALID` 일 때만 사용 가능) | N |