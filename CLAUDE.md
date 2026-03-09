# Claude.md: Flutter Riverpod 프론트엔드 프로젝트 가이드

이 프로젝트는 Flutter와 Riverpod을 기반으로 하는 프론트엔드 애플리케이션입니다.
아래 가이드라인과 워크플로우를 따라 작업해 주세요.

## 0. 최우선 원칙
- 매직넘버는 상수화하세요.
- 새로운 컴포넌트를 만들기 전에 전역 constants 과 widgets 을 먼저 확인하세요. (재사용성 중요)

--

## 1. 핵심 기술 스택

#### 버전 정보

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

## 2. 프론트엔드 디렉토리 구조 (기준안)
당신이 코드를 생성하거나 수정할 때 반드시 따라야 할 핵심 구조입니다.

```text
lib/
├── core/
│   ├── router/
│   │   ├── app_router.dart                 # 전체 라우터 설정
│   │   ├── route_names.dart                # 라우트 이름 상수
│   │   └── route_guards.dart               # 인증/권한 기반 라우트 가드
│   ├── theme/
│   │   ├── app_theme.dart                  # 앱 전체 ThemeData 설정
│   │   ├── app_colors.dart                 # 공통 색상 토큰
│   │   ├── app_text_styles.dart            # 공통 텍스트 스타일
│   │   ├── app_spacing.dart                # 공통 spacing/sizing 토큰
│   │   └── app_logo_typography.dart        # 로고 전용 타이포그래피 토큰
│   ├── constants/
│   │   ├── api_constants.dart              # API baseUrl, timeout 등 네트워크 상수
│   │   ├── app_images.dart                 # 이미지 에셋 경로 상수
│   │   ├── app_icon_assets.dart            # 아이콘 에셋 경로 상수
│   │   ├── app_mingo_assets.dart           # 밍고 캐릭터 에셋 경로 상수
│   │   ├── storage_keys.dart               # 로컬 저장소 key 모음
│   │   └── app_constants.dart              # 앱 전역 상수
│   ├── errors/
│   │   ├── app_exception.dart              # 앱 공통 예외 타입
│   │   ├── failure.dart                    # 앱 전체 UI/도메인 레벨 failure 정의
│   │   └── error_mapper.dart               # 서버/예외를 사용자용 에러로 변환
│   ├── network/
│   │   ├── dio_client.dart                 # Dio 인스턴스 생성 및 기본 설정
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart       # 토큰 첨부 처리
│   │   │   ├── logging_interceptor.dart    # 요청/응답 로깅
│   │   │   └── error_interceptor.dart      # 공통 에러 가공
│   │   ├── api_response.dart               # 공통 응답 래퍼 모델
│   │   └── network_exception.dart          # 네트워크 예외 정의
│   ├── storage/
│   │   ├── secure_storage_service.dart     # 토큰/민감정보 저장
│   │   ├── local_storage_service.dart      # 일반 로컬 저장소 래퍼
│   │   └── cache_manager.dart              # 캐시 저장/조회 정책
│   ├── utils/            # utils, extensions
│   │   ├── debug_toast.dart                # 디버그용 토스트 출력 유틸
│   │   ├── context_extension.dart          # BuildContext 확장
│   │   ├── string_extension.dart           # String 확장
│   │   ├── logger.dart                     # 로그 출력 유틸
│   │   ├── validator.dart                  # 공통 입력값 검증 유틸
│   │   ├── date_time_utils.dart            # 날짜/시간 포맷 유틸
│   │   └── debounce.dart                   # 입력 debounce 등 보조 유틸
│   ├── widgets/         # 앱 전역에서 재사용하는 UI 컴포넌트
│   │   ├── badges/
│   │   ├── buttons/
│   │   ├── dialogs/
│   │   ├── indicators/
│   │   ├── inputs/
│   │   └── layouts/
│   │       ├── mingoring_app_bar.dart      # 앱 공통 앱바 (back/title 등 타입 지원)
│   │       ├── bottom_action_layout.dart
│   │       └── page_frame.dart
│   └── services/
│       ├── analytics_service.dart          # 공통 이벤트 로깅 서비스
│       └── connectivity_service.dart       # 네트워크 상태 서비스
│
├── features/              # 기능별 모듈
│   ├── {feature}/         # 기능 이름
│   │   ├── dto/                  # API 요청 DTO, 응답 DTO (서버와 통신하기 위한 데이터 구조): 서버 기준
│   │   ├── models/               # 앱 내부 비즈니스/UI에서 쓰는 모델: 앱 기준
│   │   ├── repositories/         # 데이터 액세스 계층 (외부 서버 통신 API 호출, 로컬 DB 접근)
│   │   ├── providers/            # Riverpod 프로바이더 (Notifier)
│   │   ├── screens/              # 화면
│   │   ├── constants/            # feature 내부에서만 사용하는 상수
│   │   ├── widgets/              # feature 내부에서만 재사용하는 UI 컴포넌트
│   │   └── errors/               # feature 내부에서만 쓰이는 auth 도메인 에러 타입 (필요할때만 생성)
│   │       ├── {feature}_failure.dart        # auth 전용 에러 타입 정의 (UI, provider, state가 이 타입을 기준으로 분기)
│   │       └── {feature}_error_mapper.dart   # 서버 응답 -> auth 에러 매핑 (서버 응답을 읽어서 AuthFailure로 변환)
│   ├── onboarding/        # 회원가입/로그인/온보딩
│   ├── splash/            # 스플래시 화면
│   ├── home/              # 홈 화면
│   ├── lesson/            # 학습 카드/시청 화면
│   ├── library/           # 내 레슨 목록
│   ├── bookmarks/         # 북마크 목록
│   ├── credits/           # 시간 크레딧/광고 보상
│   ├── profile/           # 내 정보
│   └── settings/          # 설정
│
└── main.dart
     
test/                      # [테스트 구조 일치 시키기]
├── core/
└── features/
    ├── onboarding/
    ├── splash/
    ├── home/
    ├── lesson/
    ├── library/
    ├── bookmarks/
    ├── credits/
    ├── profile/
    └── settings/
    
assets/                       # 정적 파일 저장소
├── images/                   # 이미지 리소스
├── fonts/                    # 폰트 파일
└── icons/                    # 아이콘 파일
```

--
## 3. 구현 규칙
당신이 코드를 생성하거나 수정할 때 반드시 따라야 할 핵심 규칙입니다.

#### 1. 디렉토리 구조 원칙
* Feature-First (기능 중심): 앱의 모든 비즈니스 기능은 features/ 폴더 아래 독립적인 모듈(예: auth, home, lesson)로 완전히 격리하여 관리합니다.
* Core & Feature 이분화: 디렉토리 루트는 앱 전체의 기반이 되는 core/ 와 개별 비즈니스 로직이 담긴 features/ 로 심플하게 나누어 멘탈 모델을 단순화합니다.
* 실용적 계층 분리 (Pragmatic Layering): 각 Feature 내부는 복잡한 계층 분리를 피하고, 데이터 통신(dto), 앱 로직(models, repositories), 상태 관리(providers), 화면(screens, widgets)으로 명확하고 실용적으로 분리합니다.


#### 2. 계층 및 폴더별 책임 (Responsibilities)

* `core/`
   * 앱의 초기 설정, 라우팅(router/), 전역 디자인 시스템(theme/), 네트워크 통신(Dio), 로컬 스토리지, 전역 에러 및 공통 위젯 등 특정 기능에 종속되지 않는 모든 공통 자원을 위치시킵니다.
   * 어떤 특정 Feature(예: 로그인 로직)의 비즈니스 코드도 이곳에 포함되어서는 안 됩니다.

* `features/`
   * `features/{feature}/dto/`: 서버와 통신하기 위한 **서버 기준**의 데이터 구조입니다. (API 요청/응답용)
   * `features/{feature}/models/`: 앱 내부 비즈니스 로직과 UI에서 사용하는 **앱 기준**의 데이터 구조입니다.
   * `features/{feature}/repositories/`: 외부 API(`dto` 활용)나 로컬 DB를 호출하여 데이터를 가져오고, 이를 앱에서 쓸 `models`로 변환하여 반환하는 역할을 합니다.
   * `features/{feature}/providers/`: Riverpod을 활용한 상태 관리 및 비즈니스 로직 처리를 담당합니다. `repositories`를 호출해 데이터를 가져와 UI에 상태를 제공합니다.
   * `features/{feature}/screens/`: 상태(`providers`)를 구독(watch)하여 화면을 그리고 사용자 인터랙션을 처리합니다.
   * `features/{feature}/widgets/`: features 내부에서만 쓰이는 UI 컴포넌트를 정의합니다.
   * `features/{feature}/errors/`: 필요한 경우, 해당 기능에서만 발생하는 특화된 에러 타입과 매퍼를 정의합니다. (예: `auth_failure`, `auth_error_mapper`)


#### 3. 의존성 규칙 (Dependency Rules)

* **단방향 데이터 흐름:** UI(`screens`) → State(`providers`) → Data Access(`repositories`) → Network/Local 순으로 의존해야 합니다. 역방향 호출은 엄격히 금지합니다.
* **데이터 변환 의존성:** UI와 `providers`는 반드시 `models/`에 정의된 데이터만 사용해야 합니다. API 응답 원본인 `dto/` 객체가 UI 화면까지 바로 넘어와서는 안 되며, 반드시 `repositories` 계층에서 `models`로 변환(Mapping)되어야 합니다.
* **Feature 격리:** 원칙적으로 특정 피처(`features/auth`)가 다른 피처(`features/home`)의 내부 코드를 직접 import 하지 않습니다. 피처 간 이동은 `core/router/`를 통해, 공통 데이터는 `core/`를 통해 해결합니다.


#### 4. 상태 관리 (State Management)

* **Library:** Riverpod (2.0 이상 코드 제너레이션 권장)
* **ViewModel 역할:** `providers/` 내의 `Notifier` 또는 `AsyncNotifier`가 뷰모델 역할을 수행합니다.
* **비동기 처리:** API 호출 등의 비동기 로직은 Riverpod의 `AsyncValue` (data, loading, error) 패턴을 적극 활용하여 UI에서 직관적으로 로딩/에러 분기 처리를 하도록 합니다.

---

## 4. 네이밍 컨벤션

#### 파일명

* **snake_case** 사용을 원칙으로 합니다.
* 파일명 끝에 해당 파일의 역할을 명확히 명시합니다. (예: `_screen.dart`, `_provider.dart`, `_repository.dart`)
* 코드 생성 파일 (part 선언): 코드 생성이 필요한 파일(Freezed, Riverpod)은 클래스 정의 상단에 반드시 part '파일명.freezed.dart';, part '파일명.g.dart';를 선언합니다.


#### 클래스명

* **PascalCase** 사용을 원칙으로 합니다.
* 파일명 ↔ 클래스명 1:1 대응 원칙을 지킵니다.
* **예시:**
* Screen: `HomeScreen`, `LoginScreen`
* Provider: `AuthNotifier`, `LessonListProvider`
* Repository: `AuthRepository`, `UserRepository`
* Model: `UserModel`, `LessonModel` (앱 내부용)
* DTO: `LoginRequestDto`, `UserResponseDto` (서버 통신용)


#### 변수 및 메서드명

* **camelCase** 사용을 원칙으로 합니다.
* `bool` 형은 `is`, `has`, `can`, `should` 등의 접두사를 명시합니다. (예: `isLoading`, `hasError`)
* **메서드 네이밍 규칙:**
* 데이터 로딩/조회: `fetch~` (네트워크 호출), `get~` (단순 조회)
* 상태 변경 (Provider 내부): 동사형 (예: `updateProfile`, `deleteLesson`)
* UI 이벤트 핸들러: `on~` 접두사 (예: `onLoginButtonPressed`)



---

## 5. 에러 핸들링

* **에러 정의 및 매핑**: 전역(core/errors/) 및 기능별(features/**/errors/) 예외를 정의하며, error_mapper를 통해 서버 에러나 DioException을 내부 AppException 타입으로 변환합니다.
* **비즈니스 로직 에러 (Provider 담당)**: 아이디 중복, 조건 미달 등 로직 에러는 Provider에서 AppException을 throw하여 **상태(state)**로 알립니다. UI(Screen)는 이 상태를 리스닝(ref.listen)하여 자동으로 팝업을 띄웁니다.
* **순수 UI 레벨 체크 (Screen 담당)**: **단순 버튼 클릭 전 확인 등은 Screen 내에서 ErrorPopup.show()를 직접 호출합니다. (로직 복잡화 시 Provider로 이관)
* **UI 에러 노출**: 별도의 정의된 표시 영역이 없는 경우 ErrorPopup.show 메소드를 호출하여 팝업으로 에러를 알리는 것을 기본 원칙으로 합니다. 만약, TextField의 errorText와 같이 특정 입력 필드에 종속된 에러이거나, UI 내에 에러 메시지 전용 공간이 마련된 경우에는 popup이 아닌, 해당 영역에 표시합니다. AsyncValue.error 등을 감지하여 위 두 방식 중 적절한 방법을 선택해 사용자 친화적인 메시지를 노출합니다.

---

## 6. 상태 관리 및 Provider (Riverpod)

#### 핵심 원칙

* **상태 정의**: 모든 상태는 Freezed를 사용하여 불변(Immutable) 객체로 정의합니다.
* **비즈니스 로직 분리**: 상태 변경 및 화면 동작에 필요한 로직은 Notifier 내부 메서드로 관리하며, 상태 업데이트는 항상 `state = state.copyWith(...)`를 통해 수행합니다.
* **AsyncValue 활용**: API 통신뿐만 아니라, 비동기 유효성 검사(예: 추천인 코드 확인) 및 제출 상태(submitState) 관리에도 AsyncValue를 사용합니다. 단, `AsyncError` 상태에서 예외를 다시 throw하여 위젯 트리 전체가 crash되는 것을 방지하기 위해서 빌드 메서드나 Getter에서 `AsyncValue`의 값을 읽을 때는 `.value` 대신 반드시 `.valueOrNull`을 사용합니다.


#### 상태 구조 및 파생 상태 (State Structure & Computed State)

* **UI State**
  - 사용자의 입력값(input)과 그에 따른 즉각적인 유효성 상태(status, errorMessage)를 관리합니다.

* **Submit Snapshot**
  - 서버 요청에 사용될 최종 가공 데이터나 응답 결과(response)를 상태 내부에 별도로 보유하여 데이터 일관성을 유지합니다.

* **Computed State (파생 상태)**
  - UI에서 조건 판단 로직(예: 버튼 활성화 여부)을 직접 작성하지 않습니다.
  - 대신 상태 클래스 내부에 Getter를 정의하여 파생된 상태를 제공합니다.
  - 이를 통해 UI 코드를 단순하게 유지하고 상태 판단 로직을 한 곳에 집중시킵니다.


#### 비동기 로직 처리 (AsyncValue.guard)

* **일반적인 비동기 상태 관리**
    - Repository 등 외부 비동기 호출 결과는 `AsyncValue.guard`를 활용하여 `loading / data / error` 상태로 일관되게 관리합니다.
    - 이를 통해 반복적인 try-catch를 줄이고, 비동기 결과를 상태(State)에 안전하게 반영합니다.
* **결과값을 직접 반환해야 하는 경우**
    - 호출 결과를 즉시 반환하여 후속 제어 흐름(예: 화면 이동, 다음 단계 진행 여부 판단)에 사용해야 하는 경우에는 `try-catch`를 사용하여 상태 업데이트와 결과 반환을 함께 처리할 수 있습니다.

#### Repository 계층

* **인터페이스 정의**: abstract interface class를 사용하여 테스트와 교체가 용이하도록 합니다.
* **에러 매핑**: DioException 등 외부 예외를 그대로 노출하지 않고, core(또는 feature) error mapper를 통해 도메인 예외(AppException)로 변환하여 처리합니다.

---

## 7. UI-Provider 통신 패턴 (Screen에서 Provider 상태 사용 패턴)

* **상태 구독 (watch)**  
  - ref.watch를 사용하여 Provider의 상태를 구독하고, 상태가 변경될 때 UI가 자동으로 rebuild되도록 합니다.  
  - 이는 화면에 표시되는 데이터나 UI 상태(버튼 활성화, 로딩 표시 등)를 반응형으로 업데이트할 때 사용합니다.

* **상태 변화 리스닝 (listen)**  
  - ref.listen을 사용하여 특정 상태 변화에 반응하는 **side effect**를 처리합니다.  
  - 예: 네비게이션 이동, 팝업/토스트 표시, 스낵바, 로그 기록, 애니메이션 트리거 등.  
  - 이러한 로직은 UI rebuild와 분리하여 `ref.listen` 기반의 side effect 처리로 관리합니다.
