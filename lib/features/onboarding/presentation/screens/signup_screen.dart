import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../../../../core/widgets/layouts/screens/top_space_centered_bottom_layout.dart';
import '../constants/signup_screen_constants.dart';
import '../widgets/signup_name_input.dart';

/// 회원가입 화면
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _controller;
  MingoringInputTextfieldVerifyState _fieldState =
      MingoringInputTextfieldVerifyState.defaultState;
  String? _errorMessage;

  bool get _isValid =>
      _fieldState == MingoringInputTextfieldVerifyState.active;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _fieldState = MingoringInputTextfieldVerifyState.defaultState;
        _errorMessage = null;
      });
      return;
    }

    // Validation
    if (!SignupScreenConstants.nameValidChars.hasMatch(value)) {
      setState(() {
        _fieldState = MingoringInputTextfieldVerifyState.error;
        _errorMessage = SignupScreenConstants.nameSpecialChars.hasMatch(value)
            ? SignupScreenConstants.nameErrorSpecialChars
            : SignupScreenConstants.nameErrorInvalidInput;
      });
      return;
    }

    // Valid
    setState(() {
      _fieldState = MingoringInputTextfieldVerifyState.active;
      _errorMessage = null;
    });
  }

  /// Continue 버튼 또는 키보드 "완료" 시 호출.
  /// 유효하면 다음 화면으로 이동하며 키보드를 내린다.
  /// 유효하지 않으면 키보드를 유지한다.
  void _onContinue() {
    if (!_isValid) return;
    FocusScope.of(context).unfocus();
    context.go(RoutePaths.login);
  }

  /// 키보드 "완료" 버튼 핸들러.
  void _onSubmitted(String _) {
    _onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: TopSpaceCenteredBottomLayout(
          topType: TopSpaceCenteredBottomTopType.backHeader,
          onBack: () => context.pop(),
          contentVerticalAlignment: MainAxisAlignment.start,
          contentHorizontalAlignment: CrossAxisAlignment.start,
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      height: SignupScreenConstants.headerToStepperGap),
                  const MingoringProgressStepper.big(
                    maxItemCount: 3,
                    currentItem: 1,
                  ),
                  const SizedBox(
                      height: SignupScreenConstants.stepperToContentGap),
                  SignupNameInput(
                    controller: _controller,
                    fieldState: _fieldState,
                    errorMessage: _errorMessage,
                    onChanged: _onChanged,
                    onSubmitted: _onSubmitted,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          buttonText: SignupScreenConstants.buttonTextContinue,
          onPressed: _isValid ? _onContinue : null,
        ),
      ),
    );
  }
}
