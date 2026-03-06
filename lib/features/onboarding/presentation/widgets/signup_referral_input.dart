import 'package:flutter/material.dart';

import '../../../../core/widgets/buttons/mingoring_verify_button.dart';
import '../../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../constants/signup_screen_constants.dart';
/// 추천인 코드 입력 영역 위젯
/// [MingoringInputTextfieldVerify] 와 [MingoringVerifyButton] 으로 구성.
class SignupReferralInput extends StatelessWidget {
  const SignupReferralInput({
    super.key,
    required this.controller,
    required this.fieldState,
    required this.isVerifyEnabled,
    this.errorMessage,
    required this.onChanged,
    required this.onVerify,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController controller;
  final MingoringInputTextfieldVerifyState fieldState;
  final bool isVerifyEnabled;
  final String? errorMessage;
  final ValueChanged<String> onChanged;
  final VoidCallback onVerify;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MingoringInputTextfieldVerify(
            controller: controller,
            state: fieldState,
            hintText: SignupScreenConstants.referralHintText,
            showMax: false,
            maxLength: SignupScreenConstants.referralMaxLength,
            helperText: errorMessage,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
          ),
        ),
        const SizedBox(width: 8.0),
        MingoringVerifyButton(
          onPressed: isVerifyEnabled ? onVerify : null,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
