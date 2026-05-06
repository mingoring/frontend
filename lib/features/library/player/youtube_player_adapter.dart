import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 플레이어 런타임 상태 스냅샷
class YouTubePlayerState {
  const YouTubePlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.isReady = false,
  });

  final bool isPlaying;
  final Duration position;
  final bool isReady;
}

/// YouTube 플레이어 추상 인터페이스
///
/// [VideoWatchScreen]은 이 타입에만 의존합니다.
/// 구현체를 교체할 때 화면 코드는 [initState]의 생성자 한 줄만 바꾸면 됩니다.
///
/// 구현체:
/// - [YouTubePlayerFlutterAdapter] — youtube_player_flutter (현재 사용 중)
/// - YouTubePlayerIframeAdapter   — youtube_player_iframe (필요 시 추가)
abstract class YouTubePlayerAdapter {
  /// 플레이어 상태 변화를 구독할 수 있는 Listenable
  ValueListenable<YouTubePlayerState> get state;

  void play();
  void pause();
  void seekTo(Duration position);
  void setPlaybackRate(double rate);
  void dispose();

  /// 플레이어 위젯을 포함한 위젯 트리를 빌드합니다.
  ///
  /// [builder]는 실제 player 위젯을 인자로 받아 화면 레이아웃을 구성합니다.
  /// 구현체 내부에서 패키지별 래퍼(YoutubePlayerBuilder 등)를 처리하므로
  /// 화면은 [builder]만 구현하면 됩니다.
  Widget buildPlayerScaffold({
    required BuildContext context,
    required Widget Function(BuildContext context, Widget player) builder,
  });
}
