--name: naming-conventions
--description: Naming rules for files, classes, variables, and methods.
--

# Naming Conventions

## 컨벤션

- **File Names**: `snake_case` 원칙. 파일의 역할을 명확히 접미사로 명시하세요. (예: `_screen.dart`, `_provider.dart`)
- **Class Names**: `PascalCase` 원칙.
  - Screen: `HomeScreen`
  - Provider: `AuthNotifier`, `SignupNotifier`
  - Repository: `AuthRepository`
  - Model: `LessonModel` (앱 내부용)
  - DTO: `LoginRequestDto` (서버 통신용)
- **Variables**: `camelCase` 원칙. boolean 타입은 `is`, `has`, `can`, `should` 등의 접두사를 붙이세요.
- **Methods**:
  - 데이터 로딩: `fetch~` (네트워크), `get~` (단순 조회)
  - 상태 변경 (Provider 내): 동사형 (예: `updateProfile`)
  - UI 이벤트 핸들러: `on~` 접두사 (예: `onLoginButtonPressed`)

## 체크리스트

1. 이름만 보고 역할이 드러나는가?
2. bool 이름이 상태를 자연스럽게 읽히게 만드는가?
3. DTO, Model, Repository, Screen 역할이 이름에 드러나는가?