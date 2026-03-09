import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import 'signup_nickname_input.dart';
import 'signup_step_header.dart';

/// 회원가입 Step 1 - 닉네임 입력 위젯.
class SignupNicknameStep extends ConsumerStatefulWidget {
  const SignupNicknameStep({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  ConsumerState<SignupNicknameStep> createState() => _SignupNicknameStepState();
}

class _SignupNicknameStepState extends ConsumerState<SignupNicknameStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(signupNotifierProvider).nicknameInput,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MingoringProgressStepper.big(currentIndex: 0),
        const SizedBox(height: SignupScreenConstants.stepperToContentGap),
        const SignupStepHeader(
          title: SignupScreenConstants.nameTitleText,
          subtitle: SignupScreenConstants.nameSubtitleText,
        ),
        const SizedBox(height: SignupScreenConstants.subtitleToInputGap),
        Expanded(
          child: SignupNicknameInput(
            controller: _controller,
            validationStatus: state.nicknameValidationStatus,
            errorMessage: state.nicknameErrorMessage,
            onChanged: (value) =>
                ref.read(signupNotifierProvider.notifier).updateNickname(value),
            onSubmitted:
                widget.onContinue != null ? (_) => widget.onContinue!() : null,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }
}
