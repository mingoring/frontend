import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/dialogs/error_popup.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../constants/signup_screen_constants.dart';
import '../providers/signup_provider.dart';
import '../widgets/signup_interest_step.dart';
import '../widgets/signup_level_step.dart';
import '../widgets/signup_nickname_step.dart';
import '../widgets/signup_referral_step.dart';

// ─────────────────────────────────────────────────────────────────────────────

enum _SignupStep { name, level, interest, referral }

// ─────────────────────────────────────────────────────────────────────────────

/// 회원가입 화면
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  _SignupStep _currentStep = _SignupStep.name;

  bool get _isValid => switch (_currentStep) {
        _SignupStep.name => ref.watch(signupNotifierProvider).isNicknameValid,
        _SignupStep.level => ref.watch(signupNotifierProvider).isLevelValid,
        _SignupStep.interest =>
          ref.watch(signupNotifierProvider).isInterestValid,
        _SignupStep.referral =>
          ref.watch(signupNotifierProvider).isReferralValid,
      };

  bool get _isSubmitting =>
      ref.watch(signupNotifierProvider).submitState.isLoading;

  /// 추천인 코드 검증 API 호출 에러 리스너
  void _listenVerifyError() {
    ref.listen<SignupFormState>(signupNotifierProvider, (prev, next) {
      final wasError = prev?.referralCodeValidationState is AsyncError;
      final isError = next.referralCodeValidationState is AsyncError;
      if (!wasError && isError) {
        next.referralCodeValidationState.whenOrNull(
          error: (e, _) {
            // 에러 팝업 표시
            if (e is AppException) {
              ErrorPopup.show(
                context,
                errorMessage: e.message,
              );
            } else {
              ErrorPopup.show(
                context,
              );
            }
          },
        );
      }
    });
  }

  /// 회원가입 API 호출 에러 리스너
  void _listenSubmitError() {
    ref.listen<SignupFormState>(signupNotifierProvider, (prev, next) {
      final wasError = prev?.submitState is AsyncError;
      final isError = next.submitState is AsyncError;
      if (!wasError && isError) {
        next.submitState.whenOrNull(
          error: (e, _) {
            // 에러 팝업 표시
            if (e is AppException) {
              ErrorPopup.show(
                context,
                errorMessage: e.message,
              );
            } else {
              ErrorPopup.show(
                context,
              );
            }
          },
        );
      }
    });
  }

  /// Continue 버튼 또는 키보드 "완료" 시 호출.
  /// 마지막 Step이면 회원가입 API를 호출하고, 이전 Step이면 다음 Step으로 이동.
  Future<void> _onContinue() async {
    if (!_isValid || _isSubmitting) return;
    FocusScope.of(context).unfocus();

    if (_currentStep != _SignupStep.referral) {
      setState(() {
        _currentStep = _SignupStep.values[_currentStep.index + 1];
      });
      return;
    }

    final response = await ref.read(signupNotifierProvider.notifier).submit();

    if (!mounted) return;

    if (response != null) {
      context.go(RouteNames.home);
    }
  }

  void _onBack() {
    if (_currentStep != _SignupStep.name) {
      setState(() {
        _currentStep = _SignupStep.values[_currentStep.index - 1];
      });
    } else {
      context.pop();
    }
  }

  Widget _buildCurrentStep() {
    return switch (_currentStep) {
      _SignupStep.name => SignupNicknameStep(onContinue: _onContinue),
      _SignupStep.level => const SignupLevelStep(),
      _SignupStep.interest => const SignupInterestStep(),
      _SignupStep.referral => SignupReferralStep(onContinue: _onContinue),
    };
  }

  @override
  Widget build(BuildContext context) {
    _listenVerifyError();
    _listenSubmitError();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        appBar: MingoringAppBar(onBack: _onBack),
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: SignupScreenConstants.headerToStepperGap),
                      Expanded(child: _buildCurrentStep()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.contentHorizontalSpacing,
                ),
                child: MingoringTextButton(
                  onPressed: (_isValid && !_isSubmitting) ? _onContinue : null,
                  size: MingoringTextButtonSize.big,
                  child: Text(
                    _currentStep == _SignupStep.referral
                        ? SignupScreenConstants.buttonTextFinish
                        : SignupScreenConstants.buttonTextContinue,
                  ),
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
