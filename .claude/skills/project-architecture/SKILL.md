--name: project-architecture
--description: Flutter project directory structure, Layered Architecture responsibilities, and dependency rules.
--

# Project Architecture & Directory Structure

## 1. Directory Blueprint
앱 전역 기반이 되는 `core/`와 개별 비즈니스 로직이 담긴 `features/`로 분리합니다.

- `lib/core/`: router, theme(색상/타이포), constants, errors, network(Dio), storage, utils, widgets(공통 UI), services(로깅/네트워크)
- `lib/features/{feature}/`: auth, home, lesson 등 기능별 모듈
  - `dto/`: 서버 통신용 데이터 구조 (API 요청/응답)
  - `models/`: 앱 내부 비즈니스/UI용 데이터 구조
  - `repositories/`: 외부 API(`dto` 활용) 호출 후 `models`로 변환하여 반환
  - `providers/`: Riverpod 상태 관리 및 비즈니스 로직
  - `screens/`: 상태 구독 및 화면 렌더링
  - `widgets/`: Feature 내부 전용 UI 컴포넌트
  - `errors/`: Feature 특화 에러 타입 및 매퍼 (필요 시)


## 2. 의존성 규칙

- `screens/widgets -> providers -> repositories -> network/storage`
- 역방향 의존 금지
- UI와 provider는 DTO를 직접 사용하지 않습니다.
- DTO는 repository에서 model로 변환한 뒤 전달합니다.
- feature끼리 직접 내부 구현을 import하지 않습니다.
- 공통화가 필요하면 `core/`로 올립니다.


## 체크리스트

1. 이 코드가 전역 공통인지, feature 전용인지 먼저 판단합니다.
2. UI가 DTO를 직접 참조하고 있지 않은지 확인합니다.
3. repository가 변환 책임을 갖고 있는지 확인합니다.
4. 다른 feature 내부 파일을 직접 import하고 있지 않은지 확인합니다.
