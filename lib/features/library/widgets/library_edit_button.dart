import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 라이브러리 화면 상단 우측 Edit 버튼
///
/// Usage:
/// ```dart
/// LibraryEditButton(onTap: () => /* edit mode 진입 */),
/// ```
class LibraryEditButton extends StatelessWidget {
  const LibraryEditButton({
    super.key,
    required this.onTap,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final bool enabled;

  static const EdgeInsets _hitAreaPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: _hitAreaPadding,
        child: Text(
          'Edit',
          style: AppTextStyles.body7B14.copyWith(
            color: enabled ? AppColors.pink600 : AppColors.gray300,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
