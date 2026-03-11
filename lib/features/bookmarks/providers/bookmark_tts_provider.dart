import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BookmarkTtsNotifier extends Notifier<int?> {
  final FlutterTts _tts = FlutterTts();
  late final Future<void> _initializeFuture = _initialize();
  int _gen = 0;
  bool _speechStarted = false;

  @override
  int? build() {
    ref.onDispose(() => _tts.stop());
    return null;
  }

  Future<void> _initialize() async {
    try {
      await _tts.setLanguage('ko-KR');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      // completion handler는 play()에서 gen-aware로 등록
    } catch (_) {}
  }

  /// 같은 카드 → stop, 다른 카드 → 기존 중단 후 새 텍스트 재생
  Future<void> toggle(int bookmarkId, String text) async {
    if (state == bookmarkId) {
      await stop();
    } else {
      await play(bookmarkId, text);
    }
  }

  Future<void> play(int bookmarkId, String text) async {
    await _initializeFuture;
    final myGen = ++_gen;
    // _speechStarted를 동기적으로 초기화 — await 이전에 반드시 설정
    // stop()의 deferred completion이 나중에 발화해도 speechStarted=false로 차단됨
    _speechStarted = false;
    try {
      await _tts.stop();
    } catch (_) {}
    if (myGen != _gen) return;
    state = bookmarkId;
    // TTS가 실제로 발화를 시작할 때만 _speechStarted=true로 설정
    // stop completion은 발화 시작 전에 발화하므로 false 상태에서 차단됨
    _tts.setStartHandler(() {
      if (_gen == myGen) _speechStarted = true;
    });
    // speak()의 자연 완료 시에만 idle 전환 — _speechStarted로 stop completion과 구분
    _tts.setCompletionHandler(() {
      if (_gen == myGen && _speechStarted) state = null;
    });
    try {
      await _tts.speak(text);
    } catch (_) {
      if (myGen == _gen) state = null;
    }
  }

  Future<void> stop() async {
    _gen++;
    _speechStarted = false;
    state = null;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}

final bookmarkTtsProvider = NotifierProvider<BookmarkTtsNotifier, int?>(
  BookmarkTtsNotifier.new,
);
