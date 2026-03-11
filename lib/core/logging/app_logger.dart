import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'log_config.dart';

/// 앱 전역 로거
///
/// 비즈니스 로직과 로깅이 섞이지 않도록 정적 메서드로만 사용합니다.
/// 로그 출력은 비동기(microtask)로 처리되어 호출부를 블로킹하지 않습니다.
/// 릴리즈 빌드에서는 출력되지 않습니다.
///
/// 사용 예:
/// ```dart
/// AppLogger.d('[Auth] 로그인 성공');
/// AppLogger.w('[LocalStorage] 저장 실패', error: e);
/// AppLogger.e('[Network] 요청 실패', error: e, stackTrace: st);
/// ```
abstract final class AppLogger {
  static final Logger _logger = Logger(
    printer: LogConfig.printer,
    level: kDebugMode ? Level.debug : Level.off,
  );

  /// debug: 개발 중 흐름 파악용 상세 로그
  static void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(() => _logger.d(message, error: error, stackTrace: stackTrace));

  /// info: 주요 상태 변화·이벤트 기록
  static void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(() => _logger.i(message, error: error, stackTrace: stackTrace));

  /// warning: 즉각 대응은 불필요하나 주의가 필요한 상황
  static void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(() => _logger.w(message, error: error, stackTrace: stackTrace));

  /// error: 기능 실패·예외 발생 등 심각한 문제
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(() => _logger.e(message, error: error, stackTrace: stackTrace));

  /// 로그 출력을 microtask로 예약하여 호출부 블로킹을 방지합니다.
  static void _emit(void Function() fn) => unawaited(Future.microtask(fn));
}
