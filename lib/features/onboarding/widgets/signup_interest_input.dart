import 'package:flutter/material.dart';

import '../../../core/widgets/inputs/mingoring_input_selection_chip.dart';
import '../constants/signup_screen_constants.dart';

/// 관심 분야 선택 영역 위젯 (회원가입 Step 3).
/// [MingoringInputSelectionChip] (big) 리스트로 구성.
class SignupInterestInput extends StatelessWidget {
  const SignupInterestInput({
    super.key,
    required this.selectedIndexes,
    required this.onSelected,
  });

  /// 현재 선택된 관심 분야 인덱스 셋.
  final Set<int> selectedIndexes;

  /// 관심 분야 칩 탭 시 호출되는 콜백.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: SignupScreenConstants.interestChipSpacing,
        runSpacing: SignupScreenConstants.interestChipRunSpacing,
        children: List.generate(
          SignupScreenConstants.interestOptions.length,
          (index) {
            final option = SignupScreenConstants.interestOptions[index];
            return MingoringInputSelectionChip(
              size: InputSelectionChipSize.big,
              label: option,
              value: selectedIndexes.contains(index),
              onChanged: (_) => onSelected(index),
            );
          },
        ),
      ),
    );
  }
}
