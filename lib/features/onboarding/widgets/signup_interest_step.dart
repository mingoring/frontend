import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import 'signup_interest_input.dart';
import 'signup_step_header.dart';

/// 회원가입 Step 3 - 관심 분야 선택 위젯.
class SignupInterestStep extends ConsumerWidget {
  const SignupInterestStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MingoringProgressStepper.big(currentIndex: 2),
        const SizedBox(height: SignupScreenConstants.stepperToContentGap),
        const SignupStepHeader(
          title: SignupScreenConstants.interestTitleText,
          subtitle: SignupScreenConstants.interestSubtitleText,
        ),
        const SizedBox(height: SignupScreenConstants.interestSubtitleToListGap),
        Expanded(
          child: SignupInterestInput(
            selectedIndexes: state.selectedInterestIndexes,
            onSelected: (index) =>
                ref.read(signupNotifierProvider.notifier).toggleInterest(index),
          ),
        ),
      ],
    );
  }
}
