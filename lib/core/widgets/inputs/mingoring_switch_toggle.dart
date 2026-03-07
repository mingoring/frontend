import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

// 토글 스위치 사이즈
enum MingoringSwitchToggleSize {
  regular(width: 45.0, height: 28.0),
  small(width: 29.0, height: 18.0);

  const MingoringSwitchToggleSize({required this.width, required this.height});

  final double width;
  final double height;
}

// Controlled 토글 스위치
class MingoringSwitchToggle extends StatefulWidget {
  const MingoringSwitchToggle({
    super.key,
    required this.value, // 현재 상태
    this.onChanged, // 변경 콜백, null이면 Disabled
    this.size = MingoringSwitchToggleSize.regular, // 스위치 사이즈
  });

  final bool value; // 현재 상태
  final ValueChanged<bool>? onChanged; // 변경 콜백
  final MingoringSwitchToggleSize size; // 스위치 사이즈

  @override
  State<MingoringSwitchToggle> createState() => _MingoringSwitchToggleState();
}

class _MingoringSwitchToggleState extends State<MingoringSwitchToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final _SwitchPainter _painter;

  static const _kDuration = Duration(milliseconds: 200);
  static const _kDisabledOpacity = 0.38;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _kDuration,
      value: widget.value ? 1.0 : 0.0,
    );
    _painter = _SwitchPainter(
      animation: _controller,
      activeTrackColor: AppColors.pink600,
      inactiveTrackColor: AppColors.gray300,
      thumbColor: AppColors.white,
    );
  }

  @override
  void didUpdateWidget(MingoringSwitchToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.onChanged != null;

  void _handleTap() => widget.onChanged?.call(!widget.value);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: widget.value,
      enabled: _isEnabled,
      onTap: _isEnabled ? _handleTap : null,
      child: GestureDetector(
        onTap: _isEnabled ? _handleTap : null,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : _kDisabledOpacity,
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: CustomPaint(painter: _painter),
          ),
        ),
      ),
    );
  }
}

/// [repaint]에 animation을 등록하여 자체 갱신하므로 AnimatedBuilder가 불필요하다.
/// Paint 객체는 인스턴스 수명 동안 재사용된다.
class _SwitchPainter extends CustomPainter {
  _SwitchPainter({
    required Animation<double> animation,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.thumbColor,
  })  : _animation = animation,
        super(repaint: animation);

  final Animation<double> _animation;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbColor;

  final _trackPaint = Paint();
  final _thumbPaint = Paint();

  /// 모든 사이즈 프리셋이 동일한 노브/트랙 비율을 공유한다.
  static const _thumbRatio = 20.0 / 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final t = _animation.value;

    _trackPaint.color =
        Color.lerp(inactiveTrackColor, activeTrackColor, t)!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(size.height / 2),
      ),
      _trackPaint,
    );

    _thumbPaint.color = thumbColor;
    final thumbDiameter = size.height * _thumbRatio;
    final thumbRadius = thumbDiameter / 2;
    final inset = (size.height - thumbDiameter) / 2;
    final startX = inset + thumbRadius;
    final endX = size.width - inset - thumbRadius;

    canvas.drawCircle(
      Offset(startX + (endX - startX) * t, size.height / 2),
      thumbRadius,
      _thumbPaint,
    );
  }

  @override
  bool shouldRepaint(_SwitchPainter oldDelegate) {
    return oldDelegate.activeTrackColor != activeTrackColor ||
        oldDelegate.inactiveTrackColor != inactiveTrackColor ||
        oldDelegate.thumbColor != thumbColor;
  }
}
