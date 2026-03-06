import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/inputs/mingoring_input_selection_chip.dart';
import '../constants/signup_screen_constants.dart';

/// 관심 분야 선택 영역 위젯 (회원가입 Step 3).
/// 타이틀 + 서브타이틀 + [MingoringInputSelectionChip] (big) 리스트로 구성.
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SignupScreenConstants.interestTitleText,
          style: AppLogoTypography.logoEb5.copyWith(
            color: AppColors.pink600,
            height: 1.03,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.interestTitleToSubtitleGap),
        Text(
          SignupScreenConstants.interestSubtitleText,
          style: AppTypography.detail6Md12.copyWith(
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.interestSubtitleToListGap),
        Wrap(
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
      ],
    );
  }
}
