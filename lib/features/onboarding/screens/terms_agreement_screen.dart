import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/dialogs/web_view_popup.dart';
import '../../../core/widgets/inputs/mingoring_input_selection_card.dart';
import '../../../core/widgets/layouts/gradient_background.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../constants/terms_agreement_screen_constants.dart';
import '../providers/signup_provider.dart';
import '../widgets/terms_agreement_checkbox_cards.dart';

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
        .read(signupNotifierProvider.notifier)
        .setTermAgreements(List.unmodifiable(_accepted));
    context.push(RouteNames.signup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MingoringAppBar(
        onBack: () => context.pop(),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                        height: TermsAgreementScreenConstants.headerToTitleGap),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.contentHorizontalSpacing,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TermsAgreementScreenConstants.titleText,
                          style: AppLogoTypography.logoEb5
                              .copyWith(color: AppColors.pink600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            TermsAgreementScreenConstants.titleToCardAreaGap),
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
                            height:
                                TermsAgreementScreenConstants.titleCardGap),
                        for (int i = 0; i < _items.length; i++) ...[
                          if (i > 0)
                            const SizedBox(
                                height:
                                    TermsAgreementScreenConstants.cardListGap),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.contentHorizontalSpacing,
              ),
              child: MingoringTextButton(
                onPressed: _canContinue ? _onContinue : null,
                size: MingoringTextButtonSize.big,
                child: Text(TermsAgreementScreenConstants.buttonTextContinue),
              ),
            ),
            const SizedBox(height: AppSpacing.actionBottomSpacing),
          ],
        ),
        ),
      ),
    );
  }
}
