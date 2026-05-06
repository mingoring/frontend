import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/theme/app_colors.dart';
import 'youtube_player_adapter.dart';

/// youtube_player_flutter 패키지 기반 구현체
///
/// 패키지를 교체할 때는 이 파일과 동일한 인터페이스를 구현한
/// 새 어댑터 파일을 만들고, [VideoWatchScreen.initState]의
/// 생성자 호출 한 줄만 바꾸면 됩니다.
class YouTubePlayerFlutterAdapter implements YouTubePlayerAdapter {
  YouTubePlayerFlutterAdapter({required String videoId}) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        useHybridComposition: true,
      ),
    )..addListener(_syncState);
  }

  late final YoutubePlayerController _controller;
  final _stateNotifier = ValueNotifier(const YouTubePlayerState());

  @override
  ValueListenable<YouTubePlayerState> get state => _stateNotifier;

  void _syncState() {
    _stateNotifier.value = YouTubePlayerState(
      isPlaying: _controller.value.isPlaying,
      position: _controller.value.position,
      isReady: _controller.value.isReady,
    );
  }

  @override
  void play() => _controller.play();

  @override
  void pause() => _controller.pause();

  @override
  void seekTo(Duration position) => _controller.seekTo(position);

  @override
  void setPlaybackRate(double rate) => _controller.setPlaybackRate(rate);

  @override
  void dispose() {
    _controller
      ..removeListener(_syncState)
      ..dispose();
    _stateNotifier.dispose();
  }

  @override
  Widget buildPlayerScaffold({
    required BuildContext context,
    required Widget Function(BuildContext context, Widget player) builder,
  }) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.pink600,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.pink600,
          handleColor: AppColors.pink400,
        ),
      ),
      builder: builder,
    );
  }
}
