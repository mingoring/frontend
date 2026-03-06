import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/inputs/mingoring_input_selection_card.dart';
import '../constants/signup_screen_constants.dart';

/// 레벨 선택 영역 위젯 (회원가입 Step 2).
/// 타이틀 + 서브타이틀 + [MingoringInputSelectionCard] (compact) 리스트로 구성.
class SignupLevelInput extends StatelessWidget {
  const SignupLevelInput({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// 현재 선택된 레벨 인덱스 (미선택 시 null).
  final int? selectedIndex;

  /// 레벨 카드 탭 시 호출되는 콜백.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SignupScreenConstants.levelTitleText,
          style: AppLogoTypography.logoEb5.copyWith(
            color: AppColors.pink600,
            height: 1.03,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.levelTitleToSubtitleGap),
        Text(
          SignupScreenConstants.levelSubtitleText,
          style: AppTypography.detail6Md12.copyWith(
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: SignupScreenConstants.levelSubtitleToListGap),
        ...List.generate(SignupScreenConstants.levelOptions.length, (index) {
          final option = SignupScreenConstants.levelOptions[index];
          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 0 : SignupScreenConstants.levelCardGap,
            ),
            child: MingoringInputSelectionCard(
              type: InputSelectionCardType.compact,
              title: option.title,
              subtitle: option.subtitle,
              value: selectedIndex == index,
              onChanged: (_) => onSelected(index),
            ),
          );
        }),
      ],
    );
  }
}
