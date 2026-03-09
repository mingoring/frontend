import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import 'signup_referral_input.dart';
import 'signup_step_header.dart';

/// 회원가입 Step 4 - 추천인 코드 입력 위젯.
class SignupReferralStep extends ConsumerStatefulWidget {
  const SignupReferralStep({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  ConsumerState<SignupReferralStep> createState() => _SignupReferralStepState();
}

class _SignupReferralStepState extends ConsumerState<SignupReferralStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(signupNotifierProvider).referralCodeInput,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    FocusScope.of(context).unfocus();
    await ref.read(signupNotifierProvider.notifier).verifyReferralCode();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SignupScreenConstants.referralOptionalText,
          style: AppTextStyles.head7Sb18.copyWith(color: AppColors.pink300),
        ),
        const SizedBox(height: SignupScreenConstants.referralOptionalToTitleGap),
        const SignupStepHeader(
          title: SignupScreenConstants.referralTitleText,
          subtitle: SignupScreenConstants.referralSubtitleText,
        ),
        const SizedBox(height: SignupScreenConstants.subtitleToInputGap),
        Expanded(
          child: SignupReferralInput(
            controller: _controller,
            validationStatus: state.referralValidationStatus,
            isVerifyEnabled: state.canVerifyReferral,
            errorMessage: state.referralErrorMessage,
            onChanged: (value) =>
                ref.read(signupNotifierProvider.notifier).updateReferral(value),
            onVerify: _onVerify,
            onSubmitted:
                widget.onContinue != null ? (_) => widget.onContinue!() : null,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }
}
