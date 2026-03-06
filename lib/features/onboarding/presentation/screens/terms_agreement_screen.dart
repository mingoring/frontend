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
  bool _isAcceptAll = false;
  bool _isTermsOfServiceAccepted = false;
  bool _isPrivacyPolicyAccepted = false;
  bool _isPushNotificationsEnabled = false;
  bool _isMarketingEnabled = false;

  bool get _canContinue => _isTermsOfServiceAccepted && _isPrivacyPolicyAccepted;

  void _onAcceptAllChanged(bool value) {
    setState(() {
      _isAcceptAll = value;
      _isTermsOfServiceAccepted = value;
      _isPrivacyPolicyAccepted = value;
      _isPushNotificationsEnabled = value;
      _isMarketingEnabled = value;
    });
  }

  void _syncAcceptAll() {
    final all = _isTermsOfServiceAccepted &&
        _isPrivacyPolicyAccepted &&
        _isPushNotificationsEnabled &&
        _isMarketingEnabled;
    if (_isAcceptAll != all) {
      setState(() => _isAcceptAll = all);
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
                      value: _isAcceptAll,
                      onChanged: _onAcceptAllChanged,
                    ),
                    const SizedBox(
                        height: TermsAgreementScreenConstants.titleCardGap),
                    MingoringInputSelectionCard(
                      type: InputSelectionCardType.secondary,
                      title: TermsAgreementScreenConstants.termsOfServiceTitle,
                      optionalLabel: InputSelectionCardLabel.required,
                      linkButton: InputSelectionCardLinkButton.viewFull,
                      value: _isTermsOfServiceAccepted,
                      onChanged: (v) {
                        setState(() => _isTermsOfServiceAccepted = v);
                        _syncAcceptAll();
                      },
                      // TODO: 실제 링크 연결 필요
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
                      value: _isPrivacyPolicyAccepted,
                      onChanged: (v) {
                        setState(() => _isPrivacyPolicyAccepted = v);
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
                      value: _isPushNotificationsEnabled,
                      onChanged: (v) {
                        setState(() => _isPushNotificationsEnabled = v);
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
                      value: _isMarketingEnabled,
                      onChanged: (v) {
                        setState(() => _isMarketingEnabled = v);
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
