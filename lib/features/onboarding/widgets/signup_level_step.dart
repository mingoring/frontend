import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import 'signup_level_input.dart';
import 'signup_step_header.dart';

/// 회원가입 Step 2 - 레벨 선택 위젯.
class SignupLevelStep extends ConsumerWidget {
  const SignupLevelStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MingoringProgressStepper.big(currentIndex: 1),
        const SizedBox(height: SignupScreenConstants.stepperToContentGap),
        const SignupStepHeader(
          title: SignupScreenConstants.levelTitleText,
          subtitle: SignupScreenConstants.levelSubtitleText,
        ),
        const SizedBox(height: SignupScreenConstants.levelSubtitleToListGap),
        Expanded(
          child: SignupLevelInput(
            selectedIndex: state.selectedLevelIndex,
            onSelected: (index) =>
                ref.read(signupNotifierProvider.notifier).selectLevel(index),
          ),
        ),
      ],
    );
  }
}
