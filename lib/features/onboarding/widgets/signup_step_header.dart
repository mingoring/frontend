import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../constants/signup_screen_constants.dart';

/// 회원가입 Step 공통 제목/부제목 헤더 위젯.
class SignupStepHeader extends StatelessWidget {
  const SignupStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppLogoTypography.logoEb5.copyWith(color: AppColors.pink600),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.titleToSubtitleGap),
        Text(
          subtitle,
          style: AppTextStyles.body9Md14.copyWith(color: AppColors.gray600),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
