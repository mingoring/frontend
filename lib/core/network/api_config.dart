import 'dart:io';

/// 서버 API 설정 상수.
/// Base URL은 플랫폼에 따라 자동 분기된다.
///
/// - iOS 시뮬레이터 / macOS : http://localhost:8000
/// - Android 에뮬레이터      : http://10.0.2.2:8000  (에뮬레이터 내부에서 호스트 루프백)
/// - 실서버 배포 시          : 아래 _prodBaseUrl을 교체 후 빌드 환경 분기 추가.
///
// TODO(server): 배포 환경 분리 시 dev/prod baseUrl을 별도로 관리할 것.
abstract final class ApiConfig {
  ApiConfig._();

  static const String _devBaseUrlIos = 'http://localhost:8000';
  static const String _devBaseUrlAndroid = 'http://10.0.2.2:8000';

  /// 현재 실행 플랫폼에 맞는 base URL.
  static String get baseUrl =>
      Platform.isAndroid ? _devBaseUrlAndroid : _devBaseUrlIos;
}
