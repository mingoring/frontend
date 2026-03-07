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
│   ├── constants/
│   │   ├── api_constants.dart              # API baseUrl, timeout 등 네트워크 상수
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
│   │       ├── back_header.dart
│   │       ├── bottom_action_layout.dart
│   │       └── page_frame.dart
│   └── services/
│       ├── analytics_service.dart          # 공통 이벤트 로깅 서비스
│       └── connectivity_service.dart       # 네트워크 상태 서비스
│
├── features/              # 기능별 모듈
│   ├── auth/              # 로그인/회원가입
│   │   ├── dto/                  # API 요청 DTO, 응답 DTO (서버와 통신하기 위한 데이터 구조): 서버 기준
│   │   ├── models/               # 앱 내부 비즈니스/UI에서 쓰는 모델: 앱 기준
│   │   ├── repositories/         # 데이터 액세스 계층 (외부 서버 통신 API 호출, 로컬 DB 접근)
│   │   ├── providers/            # Riverpod 프로바이더
│   │   ├── screens/              # 화면
│   │   ├── constants/            # feature 내부에서만 사용하는 상수
│   │   ├── widgets/              # feature 내부에서만 재사용하는 UI 컴포넌트
│   │   └── errors/               # feature 내부에서만 쓰이는 auth 도메인 에러 타입 (필요할때만 생성)
│   │       ├── auth_failure.dart        # auth 전용 에러 타입 정의 (UI, provider, state가 이 타입을 기준으로 분기)
│   │       └── auth_error_mapper.dart   # 서버 응답 -> auth 에러 매핑 (서버 응답을 읽어서 AuthFailure로 변환)
│   ├── onboarding/        # 초기 온보딩
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
    ├── auth/
    ├── onboarding/
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
   * `features/{feature}/errors/`: 해당 기능에서만 발생하는 특화된 에러 타입과 매퍼를 정의합니다. (예: `AuthFailure`)



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

## 5. 에러 처리 및 분기 (Error Handling)

* **전역 에러 정의 (`core/errors/`):** 앱 전체에서 쓰이는 공통 예외(`AppException`)와 실패 타입(`Failure`)을 정의합니다. 네트워크 통신 오류, 타임아웃 등은 공통 `error_interceptor`에서 가공됩니다.
* **기능별 특화 에러 (`features/**/errors/`):** 로그인 실패(비밀번호 불일치, 정지된 계정 등)와 같이 특정 기능에만 종속된 에러는 해당 피처 폴더 내에 정의합니다. (예: `AuthFailure`)
* **에러 매핑 (`error_mapper`):** 서버에서 내려온 원시 에러 코드나 DioException을 앱 내부에서 이해할 수 있는 `Failure` 타입으로 변환합니다.
* **UI 에러 노출:** `screens` 에서는 예외를 `try-catch`로 잡거나 Riverpod의 `AsyncValue.error` 상태를 감지하여, 날것의 Exception 메시지 대신 사용자 친화적인 알림(Dialog, SnackBar)이나 에러 전용 위젯을 띄워줍니다.