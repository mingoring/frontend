import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../../../../core/widgets/layouts/screens/top_space_centered_bottom_layout.dart';
import '../constants/signup_screen_constants.dart';
import '../widgets/signup_interest_input.dart';
import '../widgets/signup_level_input.dart';
import '../widgets/signup_name_input.dart';

/// 회원가입 화면
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ── Common ──────────────────────────────────────────
  int _currentStep = 1;

  // ── Step 1: Name ────────────────────────────────────
  late final TextEditingController _controller;
  MingoringInputTextfieldVerifyState _fieldState =
      MingoringInputTextfieldVerifyState.defaultState;
  String? _errorMessage;

  bool get _isNameValid =>
      _fieldState == MingoringInputTextfieldVerifyState.active;

  // ── Step 2: Level ───────────────────────────────────
  int? _selectedLevelIndex;

  bool get _isLevelValid => _selectedLevelIndex != null;

  // ── Step 3: Interest ────────────────────────────────
  final Set<int> _selectedInterestIndexes = {};

  bool get _isInterestValid => _selectedInterestIndexes.isNotEmpty;

  // ── Derived ─────────────────────────────────────────
  bool get _isValid {
    if (_currentStep == 1) return _isNameValid;
    if (_currentStep == 2) return _isLevelValid;
    return _isInterestValid;
  }

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

  // ── Step 1 handlers ─────────────────────────────────
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

  // ── Common handlers ─────────────────────────────────

  /// Continue 버튼 또는 키보드 "완료" 시 호출.
  /// Step 1, 2: 유효하면 다음 Step으로 전환.
  /// Step 3: 유효하면 다음 화면으로 이동.
  void _onContinue() {
    if (!_isValid) return;
    FocusScope.of(context).unfocus();

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      context.go(RoutePaths.login);
    }
  }

  /// 키보드 "완료" 버튼 핸들러.
  void _onSubmitted(String _) {
    _onContinue();
  }

  /// Back 버튼 핸들러.
  /// Step이 1보다 크면 이전 Step으로 돌아가고, 1이면 이전 화면으로 pop.
  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
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
          onBack: _onBack,
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
                  MingoringProgressStepper.big(
                    maxItemCount: 3,
                    currentItem: _currentStep,
                  ),
                  const SizedBox(
                      height: SignupScreenConstants.stepperToContentGap),
                  if (_currentStep == 1)
                    SignupNameInput(
                      controller: _controller,
                      fieldState: _fieldState,
                      errorMessage: _errorMessage,
                      onChanged: _onChanged,
                      onSubmitted: _onSubmitted,
                      textInputAction: TextInputAction.done,
                    )
                  else if (_currentStep == 2)
                    SignupLevelInput(
                      selectedIndex: _selectedLevelIndex,
                      onSelected: _onLevelSelected,
                    )
                  else
                    SignupInterestInput(
                      selectedIndexes: _selectedInterestIndexes,
                      onSelected: _onInterestSelected,
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
