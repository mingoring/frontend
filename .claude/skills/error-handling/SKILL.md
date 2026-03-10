--name: error-handling
--description: Exception definitions, error mapping, and UI error presentation patterns.
--

# Error Handling

## 1. Error Definition & Mapping

- **Sealed Class 기반 정의**: `AppException`을 최상위로 하여 `Network`, `Server`, `Unauthorized` 등 에러 타입을 `core/errors/`에 정의합니다. 
- **에러 매핑 패턴**: 외부(Dio, 서버 응답) 예외를 그대로 UI에 노출하지 않고, `mapCommonError` 및 기능별 매퍼를 거쳐 내부 `AppException`으로 변환하여 사용합니다.
- **메시지 캡슐화**: 에러 메시지는 예외 클래스 내부에서 정의하거나 `_buildMessage`와 같은 정적 메서드를 통해 일관된 템플릿으로 관리합니다.


## 2. 레이어별 역할

- **Repository (변환 책임)**: 외부 라이브러리(Dio) 예외를 앱 내부 언어인 `AppException`으로 격리하는 최전선입니다.
    - **네트워크 예외**: `DioExceptionType`을 체크하여 `NetworkException`으로 즉시 변환합니다.
    - **서버 응답 예외**: HTTP 상태 코드와 에러 Body를 기능별 매퍼(`mapFeatureError`)에 전달하여 도메인 에러를 추출합니다.
    - **타입 방어**: 응답 데이터가 `Map<String, dynamic>`이 아닌 경우 등 예기치 못한 상황을 `UnknownException`으로 래핑하여 런타임 에러를 방지합니다.
- **Feature/Errors**: 특정 도메인에 특화된 에러 매퍼(`mapSignupError`, `mapCalendarError`)를 정의합니다. 도메인 전용 코드를 1차적으로 처리하며, 처리하지 못한 에러는 반드시 공통 매퍼(`mapCommonError`)로 위임(Delegation)합니다.
- **Core/Errors**: `AppException` 정의 및 공통 에러 매퍼(`mapCommonError`)를 통해 앱 전반의 표준 에러 처리 가이드를 제공합니다.
- **Provider (상태 전달)**: Repository에서 던져진(rethrow) `AppException`을 `AsyncError` 상태로 래핑하여 UI에 전달합니다. 비즈니스 로직 검증 실패 시 직접 `AppException`을 생성하기도 합니다.
- **Screen (상태 감시)**: UI 레이어는 에러 변환 로직에 관여하지 않습니다. 오직 `ref.listen`을 통해 전달된 `AppException`의 메시지를 다이얼로그나 토스트로 노출하는 데 집중합니다.
    - **Side Effect 기반 팝업**: `AsyncError` 감지 시 `ErrorAlertDialog.show()`를 호출하여 팝업을 띄웁니다. 이때 `prev`와 `next` 상태를 비교하여 중복 팝업 노출을 방지합니다.
    - *인라인 에러 처리**: 특정 필드와 관련된 에러는 `ErrorAlertDialog.show()`가 아닌, 특정 UI 구성 요소(TextField 등)에 직접 반영할 수 있습니다.


## 체크리스트

1. DioException이나 외부 라이브러리의 예외가 UI 레이어까지 그대로 전달되지 않고, Repository에서 AppException 타입으로 변환(rethrow)되었는가?
2. 특정 기능 전용 매퍼(mapSignupError 등)가 도메인 특화 에러를 1차 처리한 후, 나머지 에러는 mapCommonError로 적절히 위임하고 있는가?
3. 서버 응답 데이터(response.data)가 기대하는 Map 타입이 아니거나 형식이 잘못된 경우, UnknownException 등으로 래핑하여 런타임 에러를 방지했는가?
4. Screen(UI)에서 ref.listen을 사용해 AsyncError 상태를 감시하며, prev와 next 상태를 비교해 중복 팝업이 발생하지 않도록 구현했는가?
5. 에러 메시지를 UI 코드에 하드코딩하지 않고, AppException 내부 정의나 fieldName 기반의 템플릿 메시지를 활용하고 있는가?
