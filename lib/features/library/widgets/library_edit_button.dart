import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 라이브러리 화면 상단 우측 Edit 버튼
///
/// Usage:
/// ```dart
/// LibraryEditButton(onTap: () => /* edit mode 진입 */),
/// ```
class LibraryEditButton extends StatelessWidget {
  const LibraryEditButton({super.key, required this.onTap});

  final VoidCallback onTap;

  static const double _iconSize = 10.0;
  static const double _gap = 7.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit',
            style: AppTextStyles.detail6Md12.copyWith(
              color: AppColors.pink600,
              height: 1.2,
            ),
          ),
          const SizedBox(width: _gap),
          SvgPicture.asset(
            AppIconAssets.arrowRight,
            width: _iconSize,
            height: _iconSize,
            colorFilter: const ColorFilter.mode(
              AppColors.pink600,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
