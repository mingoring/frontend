import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/testtoast.dart';
import '../../../../core/widgets/inputs/mingoring_input_selection_card.dart';
import '../../../../core/widgets/layouts/screens/top_space_centered_bottom_layout.dart';
import '../constants/onboarding_constants.dart';
import '../constants/terms_agreement_screen_constants.dart';
import '../widgets/terms_agreement_checkbox_cards.dart';
import '../widgets/terms_agreement_title.dart';

/// 약관동의 화면
class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  bool _acceptAll = false;
  bool _termsOfService = false;
  bool _privacyPolicy = false;
  bool _pushNotifications = false;
  bool _marketing = false;

  bool get _canContinue => _termsOfService && _privacyPolicy;

  void _onAcceptAllChanged(bool value) {
    setState(() {
      _acceptAll = value;
      _termsOfService = value;
      _privacyPolicy = value;
      _pushNotifications = value;
      _marketing = value;
    });
  }

  void _syncAcceptAll() {
    final all = _termsOfService &&
        _privacyPolicy &&
        _pushNotifications &&
        _marketing;
    if (_acceptAll != all) {
      setState(() => _acceptAll = all);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: OnboardingConstants.backgroundGradient,
        ),
        child: TopSpaceCenteredBottomLayout(
          topType: TopSpaceCenteredBottomTopType.backHeader,
          onBack: () => context.pop(),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TermsAgreementTitle(
                  titleText: TermsAgreementScreenConstants.titleText,
                  titleStyle: AppLogoTypography.logoEb5.copyWith(
                    color: AppColors.pink600,
                    height: 1.03,
                  ),
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
                      value: _acceptAll,
                      onChanged: _onAcceptAllChanged,
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.titleCardGap),
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.secondary,
                      title: TermsAgreementScreenConstants.termsOfServiceTitle,
                      optionalLabel: InputSelectionCardLabel.required,
                      linkButton: InputSelectionCardLinkButton.viewFull,
                      value: _termsOfService,
                      onChanged: (v) {
                        setState(() => _termsOfService = v);
                        _syncAcceptAll();
                      },
                      onLinkPressed: () => TestToast.show(
                        context,
                        message: 'viewfull 클릭됨!',
                      ),
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.cardListGap),
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.secondary,
                      title: TermsAgreementScreenConstants.privacyPolicyTitle,
                      optionalLabel: InputSelectionCardLabel.required,
                      linkButton: InputSelectionCardLinkButton.viewFull,
                      value: _privacyPolicy,
                      onChanged: (v) {
                        setState(() => _privacyPolicy = v);
                        _syncAcceptAll();
                      },
                      onLinkPressed: () => TestToast.show(
                        context,
                        message: 'viewfull 클릭됨!',
                      ),
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.cardListGap),
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.secondary,
                      title: TermsAgreementScreenConstants
                          .pushNotificationsTitle,
                      optionalLabel: InputSelectionCardLabel.optional,
                      linkButton: InputSelectionCardLinkButton.viewFull,
                      value: _pushNotifications,
                      onChanged: (v) {
                        setState(() => _pushNotifications = v);
                        _syncAcceptAll();
                      },
                      onLinkPressed: () => TestToast.show(
                        context,
                        message: 'viewfull 클릭됨!',
                      ),
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.cardListGap),
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.secondary,
                      title: TermsAgreementScreenConstants.marketingTitle,
                      optionalLabel: InputSelectionCardLabel.optional,
                      linkButton: InputSelectionCardLinkButton.viewFull,
                      value: _marketing,
                      onChanged: (v) {
                        setState(() => _marketing = v);
                        _syncAcceptAll();
                      },
                      onLinkPressed: () => TestToast.show(
                        context,
                        message: 'viewfull 클릭됨!',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buttonText: TermsAgreementScreenConstants.buttonTextContinue,
          onPressed: _canContinue ? () => context.go(RoutePaths.signup) : null,
        ),
      ),
    );
  }
}
