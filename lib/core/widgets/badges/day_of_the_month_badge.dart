import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum DayOfTheMonthBadgeVariant {
  empty, // 다른 월 날짜 (빈 상태)
  incompletedPastDay, // 미학습 (과거 날짜)
  incompletedToday, // 미학습 (오늘 날짜)
  completedDay, // 학습완료
}

class DayOfTheMonthBadge extends StatelessWidget {
  const DayOfTheMonthBadge({
    super.key,
    this.date,
    required this.variant,
    this.onTap,
    this.scale = 1.0,
  });

  final int? date;
  final DayOfTheMonthBadgeVariant variant;
  final VoidCallback? onTap;
  final double scale;

  static const double _baseOuterSize = 35.0;
  static const double _baseCircleSize = 31.0;
  static const double _baseCheckIconSize = 14.0;
  static const double _baseCheckStrokeWidth = 2.5;
  static const double _baseTapRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    final outerSize = _baseOuterSize * scale;
    final tapRadius = BorderRadius.all(Radius.circular(_baseTapRadius * scale));

    final child = SizedBox(
      width: outerSize,
      height: outerSize,
      child: Center(child: _buildContent()),
    );

    if (variant == DayOfTheMonthBadgeVariant.empty || onTap == null) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: tapRadius,
      child: child,
    );
  }

  Widget _buildContent() {
    return switch (variant) {
      DayOfTheMonthBadgeVariant.empty => const SizedBox.shrink(),
      DayOfTheMonthBadgeVariant.incompletedPastDay =>
        _DateLabel(date: date, scale: scale),
      DayOfTheMonthBadgeVariant.incompletedToday => _buildIncompleteToday(),
      DayOfTheMonthBadgeVariant.completedDay => _buildCompletedDay(),
    };
  }

  Widget _buildIncompleteToday() {
    final circleSize = _baseCircleSize * scale;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: const BoxDecoration(
        color: AppColors.pink300,
        shape: BoxShape.circle,
      ),
      child: Center(child: _DateLabel(date: date, scale: scale)),
    );
  }

  Widget _buildCompletedDay() {
    final circleSize = _baseCircleSize * scale;
    final checkSize = _baseCheckIconSize * scale;
    final checkStroke = _baseCheckStrokeWidth * scale;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: const BoxDecoration(
        color: AppColors.pink600,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(checkSize, checkSize),
          painter: _CheckPainter(
            color: AppColors.white,
            strokeWidth: checkStroke,
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.50)
      ..lineTo(size.width * 0.42, size.height * 0.75)
      ..lineTo(size.width * 0.82, size.height * 0.28);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.date, required this.scale});

  final int? date;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${date ?? ''}',
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.clip,
      style: AppTextStyles.detail4B12.copyWith(
        color: AppColors.gray500,
        height: 1.0,
        fontSize: _baseFontSize * scale,
      ),
      textAlign: TextAlign.center,
    );
  }

  static const double _baseFontSize = 12.0;
}
