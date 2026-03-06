# 네비게이션 가이드 (nav.md)

> 유지보수 전용 문서. 화면 흐름·백스택·네비게이션 규칙을 기록합니다.
> 화면 추가/변경 시 반드시 이 문서도 함께 업데이트하세요.

---

## 1. 라우트 경로 상수 (`route_paths.dart`)

| 상수                  | 경로          | 화면                    |
|-----------------------|---------------|-------------------------|
| `RoutePaths.splash`   | `/splash`     | `SplashScreen`          |
| `RoutePaths.onboarding` | `/onboarding` | `OnboardingScreen`    |
| `RoutePaths.login`    | `/login`      | `LoginScreen`           |
| `RoutePaths.terms`    | `/terms`      | `TermsAgreementScreen`  |
| `RoutePaths.signup`   | `/signup`     | `SignupScreen`          |
| `RoutePaths.home`     | `/home`       | `HomeScreen`            |

모든 경로는 **절대 경로**만 사용합니다. 상대 경로(`../`) 혼용 금지.

---

## 2. 네비게이션 메서드 규칙

| 메서드           | 동작                                  | 사용 시점                              |
|------------------|---------------------------------------|----------------------------------------|
| `context.go()`   | 현재 스택을 **전부 교체**             | 스택을 초기화하고 새 루트를 세울 때    |
| `context.push()` | 현재 스택 **위에 쌓기**              | 뒤로가기로 돌아올 수 있어야 할 때      |
| `context.pop()`  | 현재 화면을 **꺼냄**                 | 명시적 뒤로가기 처리 시                |

---

## 3. 미인증 유저 화면 흐름

```
SplashScreen
    │ context.go(onboarding)          ← 스택 교체
    ▼
OnboardingScreen  ─ (내부 PageView, 스택 이동 없음)
    │ context.go(login)               ← 스택 교체 (Onboarding은 백스택에 남지 않음)
    ▼
LoginScreen                           ← 백스택의 첫 번째(루트)
    │ context.push(terms)             ← 스택에 쌓기
    ▼
TermsAgreementScreen
    │ context.push(signup)            ← 스택에 쌓기
    ▼
SignupScreen (Step 1 → 2 → 3 → 4)   ← 단일 Route, 내부 State로 Step 전환
    │ context.go(home)                ← 스택 전체 교체 (회원가입 성공)
    ▼
HomeScreen                            ← 백스택의 새 루트
```

---

## 4. 백스택 상태

### 회원가입 진행 중 (Step 1 기준)
```
[LoginScreen, TermsAgreementScreen, SignupScreen]
```

### 회원가입 성공 후
```
[HomeScreen]   ← go()로 전체 교체됨
```

---

## 5. 뒤로가기 처리

### 물리적 뒤로가기 = 상단 뒤로가기 버튼 (동일 플로우 보장)

| 화면                  | 뒤로가기 동작                                              | 구현 방식                                      |
|-----------------------|------------------------------------------------------------|------------------------------------------------|
| `LoginScreen`         | 앱 종료 (루트이므로 뒤로가기 없음)                        | GoRouter 기본 동작                             |
| `TermsAgreementScreen` | `LoginScreen`으로 이동                                   | `context.pop()` / `MingoringBackHeader`        |
| `SignupScreen` Step>1 | 이전 Step으로 이동 (화면 전환 없음)                       | `PopScope(canPop: false)` + `_onBack()` 내부 처리 |
| `SignupScreen` Step=1 | `TermsAgreementScreen`으로 이동                           | `_onBack()` → `context.pop()`                  |

### `SignupScreen` `PopScope` 구조
```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, _) {
    if (!didPop) _onBack();  // 물리적 뒤로가기 → _onBack()과 동일 플로우
  },
  child: Scaffold(...),
)
```
`_onBack()` 로직:
- `_currentStep > 1` → `setState(() => _currentStep--)` (이전 Step)
- `_currentStep == 1` → `context.pop()` (TermsAgreementScreen으로)

---

## 6. 신규 화면 추가 시 체크리스트

1. `route_paths.dart`에 경로 상수 추가
2. `app_router.dart`에 `GoRoute` 등록
3. 이 문서(nav.md)의 라우트 표 + 흐름도 업데이트
4. 네비게이션 메서드 선택 기준 확인 (`go` vs `push`)
5. 물리적 뒤로가기가 필요한 화면이면 `PopScope` 검토
