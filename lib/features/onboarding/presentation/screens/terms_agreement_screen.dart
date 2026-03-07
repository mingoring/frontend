import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/dialogs/web_view_popup.dart';
import '../../../../core/widgets/inputs/mingoring_input_selection_card.dart';
import '../../../../core/widgets/layouts/frames/page_frame.dart';
import '../../../../core/widgets/layouts/components/mingoring_back_header.dart';
import '../../../../core/widgets/buttons/mingoring_text_button.dart';
import '../constants/onboarding_constants.dart';
import '../constants/terms_agreement_screen_constants.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../widgets/terms_agreement_checkbox_cards.dart';
import '../widgets/terms_agreement_title.dart';

/// 약관동의 화면
class TermsAgreementScreen extends ConsumerStatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  ConsumerState<TermsAgreementScreen> createState() =>
      _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends ConsumerState<TermsAgreementScreen> {
  static const _items = TermsAgreementScreenConstants.items;

  List<bool> _accepted = List.filled(_items.length, false);

  bool get _isAcceptAll => _accepted.every((v) => v);

  bool get _canContinue => _items
      .asMap()
      .entries
      .where((e) => e.value.isRequired)
      .every((e) => _accepted[e.key]);

  void _onAcceptAllChanged(bool value) {
    setState(() => _accepted = List.filled(_items.length, value));
  }

  void _onItemChanged(int index, bool value) {
    setState(() => _accepted[index] = value);
  }

  void _onContinue() {
    ref
        .read(signupViewModelProvider.notifier)
        .setTermAgreements(List.unmodifiable(_accepted));
    context.push(RoutePaths.signup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: OnboardingConstants.backgroundGradient,
        ),
        child: PageFrame(
          topType: PageFrameTopType.backHeader,
          topBackHeader: MingoringBackHeader(
            onBack: () => context.pop(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                    height: TermsAgreementScreenConstants.headerToTitleGap),
                TermsAgreementTitle(
                  titleText: TermsAgreementScreenConstants.titleText,
                  titleStyle: AppLogoTypography.logoEb5
                      .copyWith(color: AppColors.pink600),
                ),
                const SizedBox(
                    height: TermsAgreementScreenConstants.titleToCardAreaGap),
                TermsAgreementCheckboxCards(
                  children: [
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.primary,
                      title: TermsAgreementScreenConstants.acceptAllTitle,
                      subtitle:
                          TermsAgreementScreenConstants.acceptAllSubtitle,
                      value: _isAcceptAll,
                      onChanged: _onAcceptAllChanged,
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.titleCardGap),
                    for (int i = 0; i < _items.length; i++) ...[
                      if (i > 0)
                        const SizedBox(
                            height: TermsAgreementScreenConstants.cardListGap),
                      MingoringInputSelectionCard(
                        type: InputSelectionCardType.secondary,
                        title: _items[i].title,
                        optionalLabel: _items[i].isRequired
                            ? InputSelectionCardLabel.required
                            : InputSelectionCardLabel.optional,
                        linkButton: _items[i].url != null
                            ? InputSelectionCardLinkButton.viewFull
                            : InputSelectionCardLinkButton.none,
                        value: _accepted[i],
                        onChanged: (v) => _onItemChanged(i, v),
                        onLinkPressed: _items[i].url != null
                            ? () => WebViewPopup.show(
                                  context,
                                  url: _items[i].url!,
                                )
                            : null,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          bottomType: PageFrameBottomType.actionButton,
          bottomActionButton: MingoringTextButton(
            onPressed: _canContinue ? _onContinue : null,
            size: MingoringTextButtonSize.big,
            child: Text(TermsAgreementScreenConstants.buttonTextContinue),
          ),
        ),
      ),
    );
  }
}
