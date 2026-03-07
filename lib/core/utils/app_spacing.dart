import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  // 상단부 ------------------------------------------------------------

  // 상단 safe 영역 여백 높이
  static double topSafeInset(BuildContext context) {
    return MediaQuery.paddingOf(context).top;
  }

  // 하단부 ------------------------------------------------------------

  // 버튼/헤더 좌우 여백 너비
  static const double buttonHorizontalPadding = 32.0;

  // TextButton 하단 여백 높이
  static double bottomMargin(BuildContext context) {
    const double ratio = 0.1;
    const double minMargin = 24.0;
    const double maxMargin = 120.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final h = MediaQuery.sizeOf(context).height;
    final calculatedMargin = (h * ratio).clamp(minMargin, maxMargin);
    return calculatedMargin < bottomInset ? bottomInset : calculatedMargin;
  }
}
