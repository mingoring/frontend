import 'package:logger/logger.dart';

/// 로거 출력 포맷 및 레벨 설정
///
/// - [methodCount]: 일반 로그에 표시할 스택 프레임 수 (0 = 스택 미표시)
/// - [errorMethodCount]: 에러 로그에 표시할 스택 프레임 수
/// - [lineLength]: 구분선 길이
abstract final class LogConfig {
  static const int _methodCount = 0;
  static const int _errorMethodCount = 5;
  static const int _lineLength = 80;

  static PrettyPrinter get printer => PrettyPrinter(
        methodCount: _methodCount,
        errorMethodCount: _errorMethodCount,
        lineLength: _lineLength,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      );
}
