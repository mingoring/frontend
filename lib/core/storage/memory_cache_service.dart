import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoryCacheServiceProvider = Provider<MemoryCacheService>((ref) {
  return MemoryCacheService();
});

// MemoryCacheService
// 앱 실행 중 잠깐 들고 있을 값 저장소 (예: greeting text, 일시적인 API 응답, 계산 결과)
class MemoryCacheService {
  int? _weekday;
  int? _hour;
  String? _text;

  /// 인사말 캐시를 조회한다. (weekday, hour, greetingText)
  /// weekday/hour가 현재와 일치할 때만 문자열을 반환한다.
  String? getGreetingTextCache({
    required int weekday,
    required int hour,
  }) {
    if (_weekday == weekday && _hour == hour && _text != null) return _text;
    return null;
  }

  /// 인사말을 캐시한다. (weekday, hour, greetingText)
  Future<void> saveGreetingTextCache({
    required int weekday,
    required int hour,
    required String greetingText,
  }) async {
    _weekday = weekday;
    _hour = hour;
    _text = greetingText;
  }

  /// 인사말 캐시를 초기화한다.
  Future<void> clearGreetingTextCache() async {
    _weekday = null;
    _hour = null;
    _text = null;
  }

  /// 캐시 데이터를 모두 정리한다.
  Future<void> clearCacheAll() async {
    await clearGreetingTextCache();
  }

  /// 로그인 사용자와 직접 관련된 캐시만 정리한다.
  Future<void> clearLoginData() async {
    // TODO: 로그인 관련 캐시 항목 추가 시 여기 작성
  }
}
