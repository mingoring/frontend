import 'package:flutter/widgets.dart';

import '../../../utils/responsive_spacing.dart';

abstract final class SpaceSizedBox {
  // safe 영역 위(상태바·노치) 높이만큼의 SizedBox
  static Widget topSafeSpace(BuildContext context) {
    return SizedBox(height: ResponsiveSpacing.topSafeInset(context));
  }

  // 하단 TextButton 하단에 올 여백 값 SizedBox
  static Widget bottomSpace(BuildContext context) {
    return SizedBox(height: ResponsiveSpacing.bottomMargin(context));
  }
}
