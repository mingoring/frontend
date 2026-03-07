import 'package:flutter/material.dart';

import '../../../core/widgets/inputs/mingoring_input_selection_card.dart';
import '../constants/signup_screen_constants.dart';

/// 레벨 선택 영역 위젯 (회원가입 Step 2).
/// [MingoringInputSelectionCard] (compact) 리스트로 구성.
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          SignupScreenConstants.levelOptions.length,
          (index) {
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
          },
        ),
      ),
    );
  }
}
