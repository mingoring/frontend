import 'package:flutter/material.dart';

import '../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../constants/signup_screen_constants.dart';

/// Nickname 입력 영역 위젯.
/// [MingoringInputTextfieldVerify] 로 구성.
class SignupNicknameInput extends StatelessWidget {
  const SignupNicknameInput({
    super.key,
    required this.controller,
    required this.validationStatus,
    this.errorMessage,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController controller;
  final MingoringValidationStatus validationStatus;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return MingoringInputTextfieldVerify(
      controller: controller,
      hintText: SignupScreenConstants.nameHintText,
      showMax: true,
      maxLength: SignupScreenConstants.nameMaxLength,
      leadingIconAsset: null,
      validationStatus: validationStatus,
      helperText: errorMessage,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
    );
  }
}
