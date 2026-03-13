import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum VideoThumbnailSize { small, big }

/// 비디오 썸네일 위젯
///
/// - [VideoThumbnailSize.small]: 90×50dp
/// - [VideoThumbnailSize.big]: 기본 140×80dp
///
/// [thumbnailUrl]
/// - 정상: 이미지 표시
/// - null or 공백 or Image.network 로드 실패(errorBuilder): 대체 배경색 표시
///
/// [width]
/// - small: 무시됨 (항상 90 고정)
/// - big: 외부에서 너비를 주입할 수 있음
///   높이는 항상 7:4 비율로 계산되어 썸네일 비율이 고정됨
class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    super.key,
    required this.size,
    this.thumbnailUrl,
    this.width,
  });

  final VideoThumbnailSize size;
  final String? thumbnailUrl;
  final double? width;

  static const double _radius = 10.0;

  static const double _smallWidth = 90.0;
  static const double _smallHeight = 50.0;

  static const double _bigDefaultWidth = 140.0;
  static const double _bigAspectRatio = 7 / 4; // 140:80

  BorderRadius get _borderRadius => switch (size) {
        VideoThumbnailSize.small =>
          const BorderRadius.all(Radius.circular(_radius)),
        VideoThumbnailSize.big => const BorderRadius.only(
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
      };

  double get _resolvedWidth => switch (size) {
        VideoThumbnailSize.small => _smallWidth,
        VideoThumbnailSize.big => width ?? _bigDefaultWidth,
      };

  double get _resolvedHeight => switch (size) {
        VideoThumbnailSize.small => _smallHeight,
        VideoThumbnailSize.big => _resolvedWidth / _bigAspectRatio,
      };

  double get _playButtonSize => switch (size) {
        VideoThumbnailSize.small => 30.0,
        VideoThumbnailSize.big => 48.0,
      };

  double get _playIconSize => switch (size) {
        VideoThumbnailSize.small => 23.0,
        VideoThumbnailSize.big => 36.0,
      };

  static const _playButtonBackgroundColor = AppColors.white85;
  static const _playIconColor = AppColors.black70;
  static const _thumbnailDimColor = AppColors.black10;

  double get _playIconOffsetX => switch (size) {
        VideoThumbnailSize.small => -0.5,
        VideoThumbnailSize.big => -1.0,
      };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: SizedBox(
        width: _resolvedWidth,
        height: _resolvedHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _thumbnailImage(),
            ColoredBox(color: _thumbnailDimColor),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _playButtonBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: _playButtonSize,
                  height: _playButtonSize,
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(_playIconOffsetX, 0),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: _playIconSize,
                        color: _playIconColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailImage() {
    final url = thumbnailUrl?.trim();
    if (url == null || url.isEmpty) {
      return _fallbackBackground();
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => _fallbackBackground(),
    );
  }

  Widget _fallbackBackground() {
    return const ColoredBox(color: AppColors.gray200);
  }
}
