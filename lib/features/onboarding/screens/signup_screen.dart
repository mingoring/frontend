import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/dialogs/error_popup.dart';
import '../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../../../core/widgets/layouts/page_frame.dart';
import '../../../core/widgets/layouts/mingoring_back_header.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import '../widgets/signup_interest_input.dart';
import '../widgets/signup_level_input.dart';
import '../widgets/signup_name_input.dart';
import '../widgets/signup_referral_input.dart';

/// 회원가입 화면
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // ── Common ──────────────────────────────────────────
  int _currentStep = 1;

  // ── Step 1: Name ────────────────────────────────────
  late final TextEditingController _controller;
  MingoringValidationStatus _nameValidationStatus =
      MingoringValidationStatus.none;
  String? _errorMessage;

  bool get _isNameValid =>
      _nameValidationStatus == MingoringValidationStatus.success;

  // ── Step 2: Level ───────────────────────────────────
  int? _selectedLevelIndex;

  bool get _isLevelValid => _selectedLevelIndex != null;

  // ── Step 3: Interest ────────────────────────────────
  final Set<int> _selectedInterestIndexes = {};

  bool get _isInterestValid => _selectedInterestIndexes.isNotEmpty;

  // ── Step 4: Referral ────────────────────────────────
  late final TextEditingController _referralController;
  MingoringValidationStatus _referralValidationStatus =
      MingoringValidationStatus.none;
  String? _referralErrorMessage;
  bool _isReferralVerified = false;

  bool get _isReferralVerifyEnabled {
    return _referralController.text.length ==
            SignupScreenConstants.referralMaxLength &&
        !_isReferralVerified &&
        _referralValidationStatus != MingoringValidationStatus.error;
  }

  bool get _isReferralValid {
    if (_referralController.text.isEmpty) return true;
    if (_isReferralVerified) return true;
    return false;
  }

  // ── Derived ─────────────────────────────────────────
  bool get _isValid {
    if (_currentStep == 1) return _isNameValid;
    if (_currentStep == 2) return _isLevelValid;
    if (_currentStep == 3) return _isInterestValid;
    return _isReferralValid;
  }

  bool get _isSubmitting {
    return ref.watch(signupNotifierProvider).submitState.isLoading;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _referralController = TextEditingController();
  }

  @override
  void dispose() {
    _referralController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ── Step 1 handlers ─────────────────────────────────
  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _nameValidationStatus = MingoringValidationStatus.none;
        _errorMessage = null;
      });
      return;
    }

    if (!SignupScreenConstants.nameValidChars.hasMatch(value)) {
      setState(() {
        _nameValidationStatus = MingoringValidationStatus.error;
        _errorMessage = SignupScreenConstants.nameSpecialChars.hasMatch(value)
            ? SignupScreenConstants.nameErrorSpecialChars
            : SignupScreenConstants.nameErrorInvalidInput;
      });
      return;
    }

    setState(() {
      _nameValidationStatus = MingoringValidationStatus.success;
      _errorMessage = null;
    });
  }

  // ── Step 2 handlers ─────────────────────────────────
  void _onLevelSelected(int index) {
    setState(() => _selectedLevelIndex = index);
  }

  // ── Step 3 handlers ─────────────────────────────────
  void _onInterestSelected(int index) {
    setState(() {
      if (_selectedInterestIndexes.contains(index)) {
        _selectedInterestIndexes.remove(index);
      } else {
        _selectedInterestIndexes.add(index);
      }
    });
  }

  // ── Step 4 handlers ─────────────────────────────────
  void _onReferralChanged(String value) {
    setState(() {
      _isReferralVerified = false;
      _referralValidationStatus = MingoringValidationStatus.none;
      _referralErrorMessage = null;
    });
  }

  void _onReferralVerify() {
    FocusScope.of(context).unfocus();
    if (_referralController.text ==
        SignupScreenConstants.tempValidReferralCode) {
      setState(() {
        _isReferralVerified = true;
        _referralValidationStatus = MingoringValidationStatus.success;
        _referralErrorMessage = SignupScreenConstants.referralSuccessText;
      });
    } else {
      setState(() {
        _isReferralVerified = false;
        _referralValidationStatus = MingoringValidationStatus.error;
        _referralErrorMessage = SignupScreenConstants.referralErrorText;
      });
    }
  }

  // ── Common handlers ─────────────────────────────────

  /// Continue 버튼 또는 키보드 "완료" 시 호출.
  /// Step 4(마지막)이면 회원가입 API를 호출하고, 이전 Step이면 다음 Step으로 이동.
  Future<void> _onContinue() async {
    if (!_isValid || _isSubmitting) return;
    FocusScope.of(context).unfocus();

    if (_currentStep < 4) {
      setState(() => _currentStep++);
      return;
    }

    // Step 4 Finish: API 호출
    final interestCodes = _selectedInterestIndexes
        .map((i) => SignupScreenConstants.interestCodes[i])
        .toList();

    final response = await ref.read(signupNotifierProvider.notifier).submit(
          nickname: _controller.text,
          level: _selectedLevelIndex! + 1,
          interestCodes: interestCodes,
        );

    if (!mounted) return;

    if (response != null) {
      context.go(RouteNames.home);
    }
  }

  /// 키보드 "완료" 버튼 핸들러.
  void _onSubmitted(String _) {
    _onContinue();
  }

  /// Back 버튼 핸들러.
  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // submitState 에러 발생 시 Dialog 표시
    ref.listen<SignupFormState>(signupNotifierProvider, (prev, next) {
      next.submitState.whenOrNull(
        error: (e, _) {
          ErrorPopup.show(
            context,
            errorMessage: e is AppException ? e.message : null,
          );
        },
      );
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white,
          ),
          child: PageFrame(
            topType: PageFrameTopType.backHeader,
            topBackHeader: MingoringBackHeader(onBack: _onBack),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      height: SignupScreenConstants.headerToStepperGap),
                  if (_currentStep < 4) ...[
                    MingoringProgressStepper.big(
                      currentIndex: _currentStep - 1,
                    ),
                    const SizedBox(
                        height: SignupScreenConstants.stepperToContentGap),
                  ] else ...[
                    Text(
                      SignupScreenConstants.referralOptionalText,
                      style: AppTextStyles.head7Sb18.copyWith(
                        color: AppColors.pink300,
                      ),
                    ),
                    const SizedBox(
                        height:
                            SignupScreenConstants.referralOptionalToTitleGap),
                  ],
                  Builder(builder: (context) {
                    final title = _currentStep == 1
                        ? SignupScreenConstants.nameTitleText
                        : _currentStep == 2
                            ? SignupScreenConstants.levelTitleText
                            : _currentStep == 3
                                ? SignupScreenConstants.interestTitleText
                                : SignupScreenConstants.referralTitleText;
                    final subtitle = _currentStep == 1
                        ? SignupScreenConstants.nameSubtitleText
                        : _currentStep == 2
                            ? SignupScreenConstants.levelSubtitleText
                            : _currentStep == 3
                                ? SignupScreenConstants.interestSubtitleText
                                : SignupScreenConstants.referralSubtitleText;
                    final gap = _currentStep == 1
                        ? SignupScreenConstants.nameSubtitleToInputGap
                        : _currentStep == 2
                            ? SignupScreenConstants.levelSubtitleToListGap
                            : _currentStep == 3
                                ? SignupScreenConstants.interestSubtitleToListGap
                                : SignupScreenConstants
                                    .referralSubtitleToInputGap;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppLogoTypography.logoEb5.copyWith(
                            color: AppColors.pink600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                            height: SignupScreenConstants.titleToSubtitleGap),
                        Text(
                          subtitle,
                          style: AppTextStyles.body9Md14.copyWith(
                            color: AppColors.gray600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: gap),
                      ],
                    );
                  }),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (_currentStep == 1) {
                        return SignupNameInput(
                          controller: _controller,
                          validationStatus: _nameValidationStatus,
                          errorMessage: _errorMessage,
                          onChanged: _onChanged,
                          onSubmitted: _onSubmitted,
                          textInputAction: TextInputAction.done,
                        );
                      }
                      if (_currentStep == 2) {
                        return SignupLevelInput(
                          selectedIndex: _selectedLevelIndex,
                          onSelected: _onLevelSelected,
                        );
                      }
                      if (_currentStep == 3) {
                        return SignupInterestInput(
                          selectedIndexes: _selectedInterestIndexes,
                          onSelected: _onInterestSelected,
                        );
                      }
                      return SignupReferralInput(
                        controller: _referralController,
                        validationStatus: _referralValidationStatus,
                        isVerifyEnabled: _isReferralVerifyEnabled,
                        errorMessage: _referralErrorMessage,
                        onChanged: _onReferralChanged,
                        onVerify: _onReferralVerify,
                        onSubmitted: _onSubmitted,
                        textInputAction: TextInputAction.done,
                      );
                    }),
                  ),
                ],
              ),
            ),
            bottomType: PageFrameBottomType.actionButton,
            bottomActionButton: MingoringTextButton(
              onPressed: (_isValid && !_isSubmitting) ? _onContinue : null,
              size: MingoringTextButtonSize.big,
              child: Text(
                _currentStep == 4
                    ? SignupScreenConstants.buttonTextFinish
                    : SignupScreenConstants.buttonTextContinue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
