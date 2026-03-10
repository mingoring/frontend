--name: state-management
--description: Riverpod state management rules, AsyncValue usage, and UI-Provider communication patterns.
--

# State Management (Riverpod)

## 1. 기본 원칙

- 상태는 가능한 한 불변 객체로 관리합니다.
- 비즈니스 상태 변경은 provider/notifier 내부에서 수행합니다. 단, 화면 내부 전용 UI 상태는 로컬 상태를 사용할 수 있습니다.
- UI는 상태를 보여주고 사용자 액션을 전달하는 역할에 집중합니다.
- 화면 로직과 상태 판단 로직은 UI에 흩뿌리지 않고 provider/state에 둡니다.


## 2. Provider & State Rules

- **Immutable State**: 공유되거나 비즈니스 로직과 연결된 상태는 Freezed를 사용하여 불변 객체로 정의합니다. 업데이트는 항상 `state = state.copyWith(...)`를 사용합니다.
- **ViewModel**: `providers/` 내의 Notifier 또는 AsyncNotifier가 ViewModel 역할을 합니다. UI의 조건 판단 로직은 상태 클래스 내부의 Getter(Computed State)로 정의하여 제공하세요.
- **AsyncValue 활용**: API 통신, 비동기 유효성 검사, 제출 상태 관리에 `AsyncValue`를 사용합니다. 위젯 트리 크래시 방지를 위해 값을 읽을 때는 `.value` 대신 .valueOrNull을 우선 사용하세요.
- **비동기 가드**: 외부 비동기 호출 결과는 `AsyncValue.guard`를 활용해 일관되게 관리합니다. 특히 Notifier의 초기화 로직(_init) 등에서 발생하는 예외는 반드시 캐치하여 안전한 상태(Default State)로 Fallback 시켜야 합니다.

## 3. UI와 Provider 통신

- **watch**: Provider의 상태를 구독하고, 상태가 변경될 때 UI가 자동으로 rebuild하는 상태 구독에 사용합니다. (예: 입력값, 로딩 여부, 활성화 상태)
- **listen**: 특정 상태 변화에 반응하는 side effect 처리에 사용합니다. (예: 팝업, 토스트, 네비게이션, 로그 기록)


## 4. API 통신 및 인증 관리 (Dio & Interceptor)

- **자동 토큰 주입 (Interceptor)**: API 요청 시 Repository 메서드의 파라미터로 토큰을 전달하지 않습니다. **Dio Interceptor**의 `onRequest` 단계에서 Secure Storage의 Access Token을 읽어와 `Authorization: Bearer <token>` 헤더를 전역적으로 자동 주입합니다.
- **Riverpod 연동**: Interceptor 내부에서 `ref.read(secureStorageServiceProvider)`를 호출하여 항상 최신 토큰 상태를 동기화합니다.
- **전역 에러 및 토큰 갱신**: 401(Unauthorized) 에러 발생 시 Interceptor의 `onError`에서 Refresh Token을 이용한 토큰 갱신 로직이나 전역 로그아웃 처리를 중앙 집중화하여 수행합니다.

## 5. 인증 상태 관리 (Auth State)

- **AuthNotifier (in-memory auth state)**: 앱 실행 중 현재 인증 상태는 Freezed 기반 AuthState Union 타입으로 Riverpod 메모리 내에서 관리합니다.
  - `loading`: 앱 초기화 시 스토리지 확인(비동기 I/O)이 끝날 때까지 대기하는 상태. UI 깜빡임 방지 및 스플래시 화면 유지.
  - `authenticated`: 유효한 토큰을 보유한 정상 회원 (홈 화면 이동)
  - `unauthenticated`: 토큰이 없거나 만료/로그아웃된 상태 (로그인 화면 표시)
  - `guest`: '게스트로 시작하기'를 선택한 상태
- **SecureStorageService**: Access/Refresh Token은 반드시 암호화하여 저장하며, '실제 인증(`authenticated`) 여부'를 판단하는 최우선 기준입니다.
- **LocalStorageService**: 토큰이 없는 경우에만, 사용자의 비인증 진입 의도(guest, logged_out)를 복원하기 위한 보조 상태 값을 저장합니다. 이 값은 인증 여부를 판단하는 기준이 아니라, 비인증 상태에서의 라우팅 보조 정보입니다.
- **초기화 및 교차 검증 흐름**: 
  1. 기동 시 `loading` 상태 시작 
  2. Secure Storage에서 토큰 확인
  3. 토큰이 존재하면 `authenticated`
  4. 토큰이 없으면 Local Storage의 상태값을 확인
  5. guest이면 guest, 그 외는 unauthenticated
  6. 라우터가 최종 상태를 감지하여 적절한 화면으로 전환
- `signIn`, `signOut`, `enterGuest` 같은 메서드는 스토리지 I/O 실패 시 state는 바꾸지 않고 예외를 다시 던져서 UI 레이어에서 에러를 처리할 수 있게 합니다. 스토리지 저장이 성공한 경우에만 state를 변경합니다.
- `AuthNotifier._init()` 중 발생한 예외는 모두 잡아서 `unauthenticated` 상태로 전환해, 스플래시 무한 대기 같은 실행 불가 상황을 방지합니다.

## 체크리스트

1. 상태 변경이 UI에서 직접 일어나지 않는가?
2. 도메인 규칙이나 폼 유효성처럼 재사용 가능한 조건은 state의 computed getter로 분리했는가?
3. 비동기 상태가 `AsyncValue`로 일관되게 관리되는가?
4. side effect가 `listen`으로 분리되어 있는가?
5. API 토큰 주입 및 갱신 처리가 Repository가 아닌 Interceptor에서 전역적으로 이루어지고 있는가?
