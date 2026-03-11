import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../theme/app_text_styles.dart';

// 시청(Watch) 버튼 사이즈
enum MingoringWatchButtonSize {
  big,
  small,
}

// 시청(Watch) 버튼 (onPressed 가 null 이면 disabled 상태)
class MingoringWatchButton extends StatelessWidget {
  const MingoringWatchButton({
    super.key,
    required this.onPressed, // 클릭 콜백 (null 이면 disabled)
    this.onLongPress, // 길게 누르기 콜백
    this.onHover, // 호버 콜백
    this.onFocusChange, // 포커스 변경 콜백
    this.size = MingoringWatchButtonSize.big, // 버튼 사이즈
    this.style, // 커스텀 버튼 스타일
    this.focusNode, // 포커스 노드
    this.autofocus = false, // 자동 포커스 여부
    this.clipBehavior, // 클립 동작 방식
    this.statesController, // 상태 컨트롤러
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final MingoringWatchButtonSize size;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;

  bool get _isEnabled => onPressed != null;

  static const double _smallPlayIconOffsetX = 1.0;

  @override
  Widget build(BuildContext context) {
    return switch (size) {
      MingoringWatchButtonSize.big => _buildBig(),
      MingoringWatchButtonSize.small => _buildSmall(),
    };
  }

  Widget _buildBig() {
    final defaultStyle = TextButton.styleFrom(
      foregroundColor: AppColors.pink50,
      disabledForegroundColor: AppColors.pink400,
      backgroundColor: AppColors.pink600,
      disabledBackgroundColor: AppColors.pink500,
      textStyle: AppTextStyles.body4B15.copyWith(height: 1.2),
      minimumSize: const Size(double.infinity, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 46),
    );

    return _buildTextButton(
      defaultStyle: defaultStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlayIcon(width: 13, height: 17),
          const SizedBox(width: 7),
          const Text('Watch'),
        ],
      ),
    );
  }

  Widget _buildSmall() {
    final defaultStyle = TextButton.styleFrom(
      foregroundColor: AppColors.pink50,
      backgroundColor: AppColors.pink600,
      disabledForegroundColor: AppColors.pink50,
      disabledBackgroundColor: AppColors.pink600,
      minimumSize: const Size(34, 34),
      fixedSize: const Size(34, 34),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      padding: EdgeInsets.zero,
    );

    return _buildTextButton(
      defaultStyle: defaultStyle,
      child: Transform.translate(
        offset: const Offset(_smallPlayIconOffsetX, 0),
        child: _buildPlayIcon(
          width: 14.96,
          height: 14.96,
          color: AppColors.pink50,
        ),
      ),
    );
  }

  Widget _buildTextButton({
    required ButtonStyle defaultStyle,
    required Widget child,
  }) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior ?? Clip.none,
      statesController: statesController,
      style: defaultStyle.merge(style),
      child: child,
    );
  }

  Widget _buildPlayIcon({
    required double width,
    required double height,
    Color? color,
  }) {
    return SvgPicture.asset(
      AppIconAssets.watchPlay,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color ?? (_isEnabled ? AppColors.pink50 : AppColors.pink400),
        BlendMode.srcIn,
      ),
    );
  }
}
