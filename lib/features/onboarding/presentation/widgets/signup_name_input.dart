import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../constants/signup_screen_constants.dart';

/// Name 입력 영역 위젯.
/// 타이틀 + 서브타이틀 + [MingoringInputTextfieldVerify] 로 구성.
class SignupNameInput extends StatelessWidget {
  const SignupNameInput({
    super.key,
    required this.controller,
    required this.fieldState,
    this.errorMessage,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController controller;
  final MingoringInputTextfieldVerifyState fieldState;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SignupScreenConstants.nameTitleText,
          style: AppLogoTypography.logoEb5.copyWith(
            color: AppColors.pink600,
            height: 1.03,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.nameTitleToSubtitleGap),
        Text(
          SignupScreenConstants.nameSubtitleText,
          style: AppTypography.detail6Md12.copyWith(
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.nameSubtitleToInputGap),
        MingoringInputTextfieldVerify(
          controller: controller,
          hintText: SignupScreenConstants.nameHintText,
          showMax: true,
          maxLength: SignupScreenConstants.nameMaxLength,
          leadingIconAsset: null,
          state: fieldState,
          helperText: errorMessage,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
