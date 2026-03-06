import 'package:flutter/widgets.dart';

abstract final class ResponsiveSpacing {
  // safe 영역 위(상태바·노치) 높이
  static double topSafeInset(BuildContext context) {
    return MediaQuery.paddingOf(context).top;
  }

  // 하단 TextButton 하단 여백 값
  static double bottomMargin(BuildContext context) {
    return _calculateBottomMargin(context);
  }

  static double _calculateBottomMargin(
    BuildContext context, {
    double ratio = 0.1,
    double minMargin = 24.0,
    double maxMargin = 120.0,
  }) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final h = MediaQuery.sizeOf(context).height;
    final calculatedMargin = (h * ratio).clamp(minMargin, maxMargin);
    
    return calculatedMargin < bottomInset ? bottomInset : calculatedMargin;
  }
}
