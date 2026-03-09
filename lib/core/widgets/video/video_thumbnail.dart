import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum VideoThumbnailSize { small, big }

/// 비디오 썸네일 위젯
///
/// - [VideoThumbnailSize.small]: 90×50dp
/// - [VideoThumbnailSize.big]: 140×80dp
///
/// [thumbnailUrl] 이미지 표시, 상단에 20% 블랙 오버레이, 중앙에 재생 아이콘
/// thumbnailUrl이 null이나 공백일 때 또는 Image.network 로드 실패(errorBuilder)일 때 대체 배경색 표시
class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    super.key,
    required this.size,
    this.thumbnailUrl,
  });

  final VideoThumbnailSize size;
  final String? thumbnailUrl;

  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(10));

  double get _width => switch (size) {
        VideoThumbnailSize.small => 90.0,
        VideoThumbnailSize.big => 140.0,
      };

  double get _height => switch (size) {
        VideoThumbnailSize.small => 50.0,
        VideoThumbnailSize.big => 80.0,
      };

  double get _circleSize => switch (size) {
        VideoThumbnailSize.small => 30.0,
        VideoThumbnailSize.big => 50.0,
      };

  double get _iconSize => switch (size) {
        VideoThumbnailSize.small => 14.0,
        VideoThumbnailSize.big => 22.0,
      };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _thumbnailImage(),
            const ColoredBox(color: AppColors.black10),
            Center(
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: const BoxDecoration(
                  color: AppColors.gray400,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: const CustomPaint(
                    painter: _PlayTrianglePainter(
                      color: AppColors.gray100,
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

class _PlayTrianglePainter extends CustomPainter {
  const _PlayTrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Figma 기준으로 아이콘을 우측으로 살짝 치우친 플레이 삼각형.
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.18)
      ..lineTo(size.width * 0.28, size.height * 0.82)
      ..lineTo(size.width * 0.82, size.height * 0.50)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PlayTrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
