회원가입 API (유저 생성, 일단 소셜 정보 제외)

POST /api/v1/auth/signup

<aside>

**[API 설명]**

- 회원가입 플로우에서 **필수 약관 동의 + 기본 회원정보 설정 + 추천인코드 등록**을 한 번에 처리한다.
- 클라이언트는 회원가입 완료 직전에 아래 값을 모두 전달한다.
    - 법적 약관 동의 4항목: `termsOfService`, `privacyPolicy`, `push`, `marketing`
    - 기본 회원정보 3항목: `nickname`, `level`, `interests`
    - 추천인코드 1항목: `referralCode`
- 서버는 요청을 검증한 뒤, 정보를 한번에 저장한다.
    
    저장 성공 시 로그인 세션 생성을 위해 인증 토큰을 함께 발급한다
    
- 변경 이력(동의/철회 시점, 버전 등)은 서버에서 별도 이력 테이블(또는 이벤트 로그)에 적재한다.
- **회원가입 플로우 전용 API이므로, 추천인코드를 제외한 모든 필드는 필수로 전달해야 한다.**
- **닉네임 유효성 검사는 클라이언트에서 1차 진행**하고, **서버에서 최종 검증**한다. (중복/정책 변경/우회 요청 등을 서버가 최종 방어)
- 시간 필드(`agreedAt`)는 API 요청/응답 및 서버/DB에서는 모두 UTC 기준으로 저장 및 처리된다. 클라이언트는 유저의 타임존을 확인하여 **UI에는 유저 타임존 기준으로 변환하여 표시**한다.
- 정책 (클라이언트는 동일 정책으로 1차 검증하되, 서버가 최종 판정)
    - **nickname 정책**
        - 길이: 최대 10자
        - 허용 문자: 한글/영문
        - 불가: 공백, 숫자, 이모지, 기타 특수문자 등
    - **level 값 정의 (중복 선택 불가능)**
        
        
        | 값 | 라벨(UI) |
        | --- | --- |
        | 1 | Lv 1 · Beginner |
        | 2 | Lv 2 · Elementary |
        | 3 | Lv 3 · Intermediate |
        | 4 | Lv 4 · Upper-Intermediate |
        | 5 | Lv 5 · Advanced |
    - **interests 코드 정의 (중복 선택 가능)**
        
        
        | 코드 | 라벨(UI) |
        | --- | --- |
        | K_POP | K-pop |
        | K_DRAMA_MOVIES | K-Drama & Movies |
        | DAILY_LIFE | Daily Life |
        | TRAVEL | Travel |
        | BUSINESS | Business |
        | BEAUTY_FASHION | Beauty & Fashion |
        | K_FOOD | K-Food |
        | GAMING | Gaming |
        | WEBTOON | Webtoon |
        | TRENDS_SLANG | Trends & Slang |
    - referralCodeStatus (무조건 아래 케이스 중 하나로 응답감)
        
        
        | referralCodeStatus | 의미 |
        | --- | --- |
        | NONE | 추천인 코드 등록을 요청하지 않은 상태 |
        | GRANTED | 추천인 코드가 정상적으로 적용되고 리워드가 지급된 상태 |
        | INVALID_REQUEST | 요청 값이 누락되었거나 형식(길이, 허용 문자 등) 정책을 위반한 경우 |
        | REFERRAL_CODE_NOT_FOUND | 입력한 추천인 코드가 존재하지 않거나 비활성/만료 상태인 경우 |
        | REFERRAL_ALREADY_APPLIED | 가입자가 이미 추천인 코드를 적용한 이력이 있어 재적용이 불가능한 경우 |
        | SELF_REFERRAL_NOT_ALLOWED | 입력한 추천인 코드가 본인 소유 코드로, 자기 추천이 시도된 경우 |
        | UNKNOWN_ERROR | 서버 내부 오류 등으로 처리 결과를 확정할 수 없는 예외 상황 |
    - 추천인 코드 관련 도메인 규칙
        - 서버는 추천인 코드를 검증한 뒤, **시간 크레딧(분 단위)** 을 지급하고 이력을 적재한다.
            - 지급 정책
                - 가입자(referee)에게 60min 리워드 증정
                - 추천인(referrer)에게 60min 리워드 증정
        - 핵심 규칙
            - **가입자 1명당 추천인 코드 등록은 최초 1회만 가능** (재등록/변경 불가)
            - **자기 자신 코드 등록 불가**
            - **추천인 코드 유효성 검증**
            - **중복 지급 방지(idempotent)**: 동일 유저의 중복 호출 또는 네트워크 재시도로 지급이 중복되지 않아야 함
        - 서버 처리 규칙
            - 로그인 유저를 **가입자(referee)** 로 확정, `referralCode`로 **추천인(referrer)** 유저에게 지급
                - 추천인코드 유효성 검증은 별도의 API 에서 수행됨. 따라서 본 API는 회원가입 요청이므로 추천인 등록에 실패해도 모두 API 성공 응답임.  응답 referralCodeStatus만 다를 뿐임.
            - 아래 조건을 모두 만족해야 지급 (서버에서 처리)
                - referee가 과거에 추천인 코드를 적용한 적 없음(최초 1회)
                - self-referral 아님(referrer ≠ referee)
                - referralCode가 유효(존재/활성/만료 아님)
            - 지급: referee +60분, referrer +60분
            - 이력 적재
        - 시간 필드(`grantedAt`)는 API 요청/응답 및 서버/DB에서는 모두 UTC 기준으로 저장 및 처리된다. 클라이언트는 유저의 타임존을 확인하여 **UI에는 유저 타임존 기준으로 변환하여 표시**한다.
</aside>

## Request

**Header**

없음

**Query**

없음

**Body**

```jsx
{
  "termsOfServiceAgreed": true,
  "privacyPolicyAgreed": true,
  "pushAgreed": false,
  "marketingAgreed": true,
  "nickname": "eunjeong",
  "level": 2,
  "interests": ["K_POP", "K_DRAMA_MOVIES", "TRAVEL"],
  "referralCode": "ABCD1234"
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| Boolean | termsOfServiceAgreed | 이용약관 동의 정보 | N |
| Boolean | privacyPolicyAgreed | 개인정보처리방침 동의 정보 | N |
| Boolean | pushAgreed | 학습 알림 수신 동의 정보 | N |
| Boolean | marketingAgreed | 마케팅/프로모션 알림 수신 동의 정보 | N |
| String | nickname | 닉네임 (서버 최종 검증 대상) | N |
| int | level | 레벨 선택 값 (1~5) | N |
| List(String) | interests | 관심분야 코드 리스트 (복수 선택) | N |
| String | referralCode | 가입자가 입력한 추천인 코드(추천인 식별) | Y |

## Response `201`

```json
{
  "userId": 123456,
  "accessToken": "<ACCESS_TOKEN>",
  "refreshToken": "<REFRESH_TOKEN>"
  "referralCodeStatus": "GRANTED"
}
```

| 타입 | 필드명 | 설명 | nullable |
| --- | --- | --- | --- |
| long | userId | 유저ID (PK) | N |
| String | accessToken | 회원가입 완료 후 발급되는 액세스 토큰 | N |
| String | refreshToken | 회원가입 완료 후 발급되는 리프레시 토큰 | N |
| String | referralCodeStatus | 추천인코드 적용 상태 | N |

## Error Response `400` : 필수 약관이 false

- 발생 케이스: `termsOfServiceAgreed.agreed == false`또는 `privacyPolicyAgreed.agreed == false`

```json
{
  "code": "CONSENT_REQUIRED",
  "message": "필수 약관에 동의해야 합니다."
}
```

## Error Response `400` : 닉네임 정책 위반

- 발생 케이스: 전달은 했으나 유효하지 않음(ex. 빈 문자열, 길이 초과, 허용되지 않은 문자 포함)

```json
{
  "code": "INVALID_NICKNAME",
  "message": "닉네임 형식이 올바르지 않거나 허용되지 않는 문자가 포함되었습니다."
}
```

## Error Response `400` : level 값 오류

- 발생 케이스: `level`이 1~5 범위를 벗어남

```json
{
  "code": "INVALID_LEVEL",
  "message": "레벨 값은 지정된 범위 내의 정수여야 합니다."
}
```

## **Error Response `400` : interests 값 오류**

- 발생 케이스: 허용되지 않은 interest 코드 포함

```json
{
  "code": "INVALID_INTERESTS",
  "message": "선택한 관심분야가 유효하지 않습니다."
}
```