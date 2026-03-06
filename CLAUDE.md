# Claude.md: Flutter Riverpod 프론트엔드 프로젝트 가이드

이 프로젝트는 Flutter와 Riverpod을 기반으로 하는 프론트엔드 애플리케이션입니다.
아래 가이드라인과 워크플로우를 따라 작업해 주세요.

## 0. 최우선 원칙
- 매직넘버는 상수화하세요.
- 새로운 컴포넌트를 만들기 전에 constants 과 widgets 을 먼저 확인하세요. (재사용성 중요)


## 1. 핵심 기술 스택

### 버전 정보
- **언어**: Dart 3.6.0
- **프레임워크**: Flutter 3.27.0
- **상태 관리**:
  - flutter_riverpod: 2.6.1
  - riverpod: 2.6.1
  - riverpod_annotation: 2.6.1
  - riverpod_generator: 2.6.4 (dev)
- **아키텍처**: MVVM + Clean Architecture (Layered Architecture)
- **직렬화**:
  - freezed: 2.5.8 (dev)
  - freezed_annotation: 2.4.4
  - json_serializable: 6.9.5 (dev)
  - json_annotation: 4.9.0
- **코드 생성**: build_runner: 2.5.4 (dev)
- **린트**: flutter_lints: 5.0.0 (dev)


---

## 2. 프론트엔드 코드 컨벤션 요약
당신이 코드를 생성하거나 수정할 때 반드시 따라야 할 핵심 규칙입니다.

### 디렉토리 구조 (기준안)
```
lib/
├── main.dart
├── core/                    # 전역 공유 코드
│   ├── network/             # Dio, API Client 설정, 서버 통신 관련
│   ├── di/                  # 의존성 주입 (service_locator.dart 등)
│   ├── router/              # 화면 이동 관리, 라우팅 설정
│   ├── errors/              # 공통 에러 정의
│   ├── constants/           # 상수 (색상, 문자열, 사이즈 등)
│   ├── utils/               # 유틸 함수
│   ├── extensions/          # extension 메서드
│   └── widgets/             # 공통 위젯
│       ├── badges/          # 입력 없는 라벨 칩 요소들
│       ├── buttons/         # 클릭 가능한 요소들
│       ├── inputs/          # 입력받는 요소들 (텍스트필드, 체크박스 등)
│       ├── dialogs/         # 팝업, 알럿, 바텀시트
│       ├── indicators/      # 로딩, 상태 표시
│       └── layouts/         # 배치, 구분선, 스캐폴드
├── features/
│   ├── auth/                    # [기능별로 폴더링]
│   │   ├── data/                # 데이터 계층 (구현 중심)
│   │   │   ├── models/          # DTO / 데이터 모델 (JSON 직렬화)
│   │   │   ├── repositories/    # Repository 구현체 (Domain의 인터페이스 구현)
│   │   │   └── datasources/     # 데이터 소스 (API, Local DB)
│   │   │       ├── remote       # 원격 API 호출
│   │   │       └── local        # 로컬 저장소
│   │   ├── domain/              # 비즈니스 로직 계층
│   │   │   ├── entities/        # 순수 비즈니스 엔티티 (JSON 의존성 X)
│   │   │   ├── repositories/    # Repository 인터페이스 (추상)
│   │   │   └── usecases/        # 유스케이스 (행동 단위)
│   │   └── presentation/        # UI 계층
│   │       ├── screens/         # 화면(Page)
│   │       ├── widgets/         # 재사용 UI 컴포넌트
│   │       └── viewmodels/      # 상태 관리 (MVVM)
│   ├── study/                   # [기능별로 폴더링]
│   │   ├── data/                # 데이터 계층 (구현 중심)
│   │   ├── domain/              # 비즈니스 로직 계층
│   │   └── presentation/        # UI 계층

test/                            # [테스트 구조 일치 시키기]
├── core/
└── features/
├── auth/
└── study/

assets/                       # 정적 파일 저장소
├── images/                   # 이미지 리소스
├── fonts/                    # 폰트 파일
└── icons/                    # 아이콘 파일
```

### 구현 규칙
#### 1. 디렉토리 구조 원칙
- Feature-first: 모든 기능은 features/ 폴더 아래 기능별(auth, study 등)로 격리하여 관리합니다.
- Layered Structure: 각 Feature 내부는 data, domain, presentation 3계층으로 철저히 분리합니다.
- Pragmatic Core: 전역으로 사용되는 공통 요소는 core/ 내부에 명확한 역할별(network, di, widgets 등)로 분류합니다.

#### 2. 계층별 책임 (Layer Responsibilities)
- core/ (전역 공유 및 인프라)
  - 앱의 뼈대가 되는 인프라와 모든 기능에서 공통으로 쓰는 자원입니다.
  - 특정 Feature의 비즈니스 로직을 알면 안 됩니다. (Feature → Core 의존만 가능)

- domain/ (비즈니스 로직 - Feature 내부)
  - 앱의 핵심 "규칙"과 "데이터 구조"를 정의합니다.
  - 가장 안쪽 계층으로, 아무런 외부 라이브러리(Flutter UI, Data Layer 등)에 의존하지 않습니다.

- data/ (데이터 구현 - Feature 내부)
  - 실제 데이터를 가져오고 변환하는 역할을 합니다.
  - Domain 계층의 인터페이스를 실제 코드로 구현합니다.

- presentation/ (UI 및 상태 - Feature 내부)
  - 사용자에게 화면을 보여주고 입력을 받습니다.
  - 유일하게 BuildContext와 Flutter UI 패키지를 사용합니다.

#### 3. 의존성 규칙 (Dependency Rules)
- 단방향 의존: Presentation → Domain ← Data (Data와 Presentation은 서로 모릅니다.)
- 역방향 금지: Data 계층이 Presentation 코드를 import 하거나, Domain이 Data 코드를 import 하면 안 됩니다.
- Feature 격리: 원칙적으로 features/auth가 features/study를 직접 import 하지 않습니다. (필요 시 Core의 Interface나 Router 활용)

#### 4. 데이터 변환 흐름 (Data Flow)
- Model: freezed + json_serializable 사용 (fromJson, toJson 포함)
- Entity: freezed 사용 (JSON 의존성 없음, 순수 Dart 객체)

#### 5. 상태 관리 (State Management)
- Library: Riverpod (2.0+) 사용
- ViewModel: AsyncNotifierProvider 또는 NotifierProvider로 관리
- Pattern: UI는 ViewModel의 상태를 ref.watch로 구독, 비동기 로직(API 호출 등)은 AsyncValue (data, loading, error)로 처리

#### 6. 계층별 상세 가이드
- `core/` : 공통 요소
  - network/
    - Dio 설정, Interceptors(토큰/로깅), ApiResponse 공통 DTO
  - di/
    - GetIt 설정, ServiceLocator(의존성 주입 진입점)
  - router/
    - GoRouter 설정, RoutePaths(경로 상수), Guards(접근 제어)
  - widgets/
    - 전역 공통 위젯
  - utils/
    - 포맷터 등 순수 헬퍼 함수

- `features/**/domain` : 비즈니스 코어
  - entities/
    - 비즈니스 모델 (예: User, StudyGroup)
    - JSON/플랫폼 의존성 없음
  - repositories/
    - 데이터 접근 추상 인터페이스 (예: AuthRepository)
  - usecases/
    - 사용자 행동 단위 (예: LoginUseCase, GetStudyListUseCase)

- `features/**/data` : 구현 상세
  - models/
    - 서버 응답 DTO (예: UserResponse, UserRequest)
    - Entity 변환 메서드 포함 (toDomain)
  - datasources/
    - remote/
      - API 호출 (Dio Client 등)
    - local/
      - DB, SharedPreferences 접근
  - repositories/
    - Domain Repository 구현체
    - Datasource 조합 및 에러 처리

- `features/**/presentation` : 화면 및 인터랙션
  - screens/
    - 실제 페이지 (Scaffold 단위, StatelessWidget 권장)
  - viewmodels/
    - Riverpod Notifier
    - 비즈니스 로직 수행 및 상태 관리
  - widgets/
    - 해당 Feature 전용 UI 컴포넌트


### 네이밍 컨벤션
#### 파일명
- snake_case 사용
- 파일명에 역할을 명시 (screen / view_model / repository / use_case)

#### 클래스명
- PascalCase 사용
- 파일명 ↔ 클래스명 1:1 대응, suffix로 역할 구분
- 예시
  - Screen: `ProductListScreen`, `ProductDetailScreen`
  - ViewModel: `ProductListViewModel`, `UserProfileViewModel`
  - Repository: `ProductRepository`, `UserRepository`
  - UseCase: `AddProductUseCase`, `GetProductsUseCase`
  - Entity: `Product`, `User`
  - Model: `ProductModel`, `UserModel`

#### 변수명
- camelCase 사용
- bool 형은 is, has, can 접두사 명시
- List 형은 복수형
- Map은 기준 명확히 (예: favoriteStatusByProductId;)

#### 메서드명
```dart
// UseCase
Future<void> execute();
Future<void> call(Product product);

// ViewModel
Future<void> loadProducts();     // 데이터 로딩 → load
void onAddProductClicked();      // UI 이벤트 → on
void updateQuantity(int value);  // 상태 변경 → 동사
```

### Provider 네이밍 (Riverpod 2.0+ 코드 생성)
- `@riverpod` 어노테이션 사용, 자동 생성된 Provider 활용

---

## 3. 추가 가이드

### Widget 설계 원칙
- **재사용성**: 공통 UI는 `core/widgets/`에 분리
- **단일 책임**: 하나의 Widget은 하나의 역할만
- **const 생성자**: 가능한 `const` 사용 (성능 최적화)

### 에러 처리
- core/errors에 공통 에러 타입(AppException) 정의: AppException(sealed class) + 하위 타입들
- error가 AppException이면 타입별 메시지/액션 제공, 그 외면 UnknownException으로 래핑 후 공통 처리
- Data layer에서 Dio/파싱 에러를 AppException으로 매핑
- Repository는 “도메인 규약”대로 실패를 던짐: throw AppException
- ViewModel에서는 AsyncValue.guard 패턴
- UI는 문자열 대신 “표준 에러 위젯”으로 처리
