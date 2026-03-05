import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

enum AppCheckboxSize {
  big(24),
  small(16);

  const AppCheckboxSize(this.dimension);
  final double dimension;
}

/// [onChanged]가 null이면 disabled (탭 불가 + opacity 조정).
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.isSelected,
    this.size = AppCheckboxSize.big,
    this.onChanged,
  });

  final bool isSelected;
  final AppCheckboxSize size;
  final ValueChanged<bool>? onChanged;

  bool get _isEnabled => onChanged != null;

  static const double _disabledOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: isSelected,
      enabled: _isEnabled,
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onTap: _isEnabled ? () => onChanged!(!isSelected) : null,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : _disabledOpacity,
          child: SizedBox(
            width: size.dimension,
            height: size.dimension,
            child: CustomPaint(
              painter: _CheckboxPainter(
                isSelected: isSelected,
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({
    required this.isSelected,
    required this.size,
  });

  final bool isSelected;
  final AppCheckboxSize size;

  static const double _circleStroke = 1.0;
  static const double _checkStroke = 1.5;

  static const double _ckX0 = -0.50, _ckY0 = -0.01;
  static const double _ckX1 = -0.19, _ckY1 = 0.29;
  static const double _ckX2 = 0.48, _ckY2 = -0.33;

  final Paint _fillPaint = Paint();

  final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _circleStroke;

  final Paint _checkPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _checkStroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final Path _checkPath = Path();

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final side = canvasSize.shortestSide;
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = side / 2;

    switch (size) {
      case AppCheckboxSize.big:
        _paintBig(canvas, center, radius);
      case AppCheckboxSize.small:
        _paintSmall(canvas, center, radius);
    }
  }

  void _paintBig(Canvas canvas, Offset center, double radius) {
    final r = radius - _circleStroke / 2;

    if (isSelected) {
      canvas.drawCircle(center, r, _fillPaint..color = AppColors.pink100);
      canvas.drawCircle(center, r, _strokePaint..color = AppColors.pink600);
      _drawCheckmark(canvas, center, radius, AppColors.pink600);
    } else {
      canvas.drawCircle(center, r, _fillPaint..color = AppColors.white);
      canvas.drawCircle(center, r, _strokePaint..color = AppColors.gray400);
    }
  }

  void _paintSmall(Canvas canvas, Offset center, double radius) {
    if (isSelected) {
      canvas.drawCircle(center, radius, _fillPaint..color = AppColors.pink600);
      _drawCheckmark(canvas, center, radius, AppColors.white);
    } else {
      final r = radius - _circleStroke / 2;
      canvas.drawCircle(center, r, _fillPaint..color = AppColors.white);
      canvas.drawCircle(center, r, _strokePaint..color = AppColors.gray400);
    }
  }

  void _drawCheckmark(Canvas canvas, Offset c, double r, Color color) {
    _checkPaint.color = color;
    _checkPath
      ..reset()
      ..moveTo(c.dx + _ckX0 * r, c.dy + _ckY0 * r)
      ..lineTo(c.dx + _ckX1 * r, c.dy + _ckY1 * r)
      ..lineTo(c.dx + _ckX2 * r, c.dy + _ckY2 * r);
    canvas.drawPath(_checkPath, _checkPaint);
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter oldDelegate) {
    return oldDelegate.isSelected != isSelected || oldDelegate.size != size;
  }
}
