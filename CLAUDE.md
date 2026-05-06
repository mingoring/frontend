# Claude.md: Flutter Frontend Base Rules

이 프로젝트는 Flutter 기반 프론트엔드 애플리케이션입니다.
코드를 생성하거나 수정할 때 아래 규칙을 항상 따릅니다.

## 0. 최우선 원칙

- 매직넘버는 상수화합니다.
- 새 컴포넌트를 만들기 전에 기존 `core/` 공통 위젯, 상수, 테마를 먼저 확인합니다.
- 기능 코드는 `features/` 아래에 위치시키고, 전역 공통 코드는 `core/` 아래에 둡니다.
- UI는 API DTO를 직접 사용하지 않습니다. DTO는 repository에서 앱 모델로 변환한 뒤 사용합니다.
- 의존성은 단방향으로 유지합니다: `screens/widgets -> providers -> repositories -> network/storage`
- 특정 feature 내부 구현을 다른 feature에서 직접 import하지 않습니다.

## 1. 기본 구조

- `core/`: 라우터, 테마, 상수, 공통 에러, 네트워크, 스토리지, 공용 위젯
- `features/{feature}/`: 기능별 화면, 상태관리, 모델, DTO, 저장소
- `test/`: `lib/` 구조를 가능한 한 동일하게 맞춥니다.

## 2. 구현 기준

- 새 기능은 feature-first 구조를 따릅니다.
- 전역 재사용이 필요한 UI만 `core/widgets/`에 둡니다.
- feature 내부 전용 UI는 해당 feature의 `widgets/`에 둡니다.
- 상태 변경 로직은 UI가 아니라 provider/notifier에 둡니다.
- 서버 응답, 예외, 저장소 구현 세부사항을 UI에 직접 노출하지 않습니다.

## 3. 필요 시 불러올 Skills

- Flutter 프로젝트 전체 아키텍처/폴더 구조: .claude/skills/project-architecture/SKILL.md
- Riverpod 상태관리, 인증/인가 처리: .claude/skills/state-management/SKILL.md
- 에러 처리: .claude/skills/error-handling/SKILL.md
- 네이밍 컨벤션: .claude/skills/naming-conventions/SKILL.md
- 컴포넌트 구현: .claude/skills/flutter-component-builder/SKILL.md


## 4. 로컬 저장소 활용

- AuthNotifier(in-memory auth state): Freezed 기반 AuthState Union 타입의 앱 실행 중 현재 인증 상태 저장소.
- MemoryCacheService: 인사말, 일시적 API 응답, 계산 결과 등 앱 실행 중에만 유지하면 되는 휘발성 캐시 저장소. 
- SecureStorageService: Access/Refresh Token을 암호화하여 저장하는 저장소.
- LocalStorageService: 앱 재실행 후에도 유지되어야 하는 값 저장소. (예: nickname, onboarding flag, 설정값)
