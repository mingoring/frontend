import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/widgets/inputs/mingoring_input_textfield_verify.dart';
import '../constants/signup_screen_constants.dart';
import '../constants/terms_agreement_screen_constants.dart';
import '../models/terms_info_model.dart';
import '../models/signup_response_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/referral_repository.dart';

part 'signup_provider.freezed.dart';
part 'signup_provider.g.dart';

// ── Nickname Validation ───────────────────────────────────────────────────────

({MingoringValidationStatus status, String? message}) _validateNickname(
    String value) {
  if (value.isEmpty) {
    return (status: MingoringValidationStatus.none, message: null);
  }
  if (!SignupScreenConstants.nameValidChars.hasMatch(value)) {
    return (
      status: MingoringValidationStatus.error,
      message: SignupScreenConstants.nameSpecialChars.hasMatch(value)
          ? SignupScreenConstants.nameErrorSpecialChars
          : SignupScreenConstants.nameErrorInvalidInput,
    );
  }
  return (status: MingoringValidationStatus.success, message: null);
}

// ── ViewModel State ───────────────────────────────────────────────────────────

/// 회원가입 흐름 전체 상태.
@freezed
class SignupFormState with _$SignupFormState {
  const SignupFormState._();

  const factory SignupFormState({
    // ── UI States (유저가 화면에서 보고 입력하는 것들) ───────────────────────────
    @Default([false, false, false, false]) List<bool> termAgreements,
    @Default('') String nicknameInput,
    @Default(MingoringValidationStatus.none)
    MingoringValidationStatus nicknameValidationStatus,
    String? nicknameErrorMessage,
    int? selectedLevelIndex,
    @Default(<int>{}) Set<int> selectedInterestIndexes,
    @Default('') String referralCodeInput,
    @Default(AsyncValue<bool?>.data(null))
    AsyncValue<bool?> referralCodeValidationState,

    // ── Submit Snapshot (서버에 제출될 최종 데이터) ────────────────────────────
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> submitState,
    String? nickname,
    int? level,
    List<String>? interestCodes,
    String? referralCode,
    SignupResponseModel? signupResponse,
  }) = _SignupFormState;

  // ── Computed: Nickname ────────────────────────────────────────────────────

  bool get isNicknameValid =>
      nicknameValidationStatus == MingoringValidationStatus.success;

  // ── Computed: Level / Interest ────────────────────────────────────────────

  bool get isLevelValid => selectedLevelIndex != null;
  bool get isInterestValid => selectedInterestIndexes.isNotEmpty;

  // ── Computed: Referral ────────────────────────────────────────────────────

  bool get isReferralVerified => referralCodeValidationState.value == true;

  bool get isReferralValid =>
      referralCodeInput.isEmpty || referralCodeValidationState.value == true;

  bool get canVerifyReferral =>
      referralCodeInput.length == SignupScreenConstants.referralMaxLength &&
      !referralCodeValidationState.isLoading &&
      referralCodeValidationState.value != true;

  MingoringValidationStatus get referralValidationStatus =>
      referralCodeValidationState.when(
        data: (isValid) {
          if (isValid == null) return MingoringValidationStatus.none;
          return isValid
              ? MingoringValidationStatus.success
              : MingoringValidationStatus.error;
        },
        error: (_, __) => MingoringValidationStatus.error,
        loading: () => MingoringValidationStatus.none,
      );

  String? get referralErrorMessage => switch (referralValidationStatus) {
        MingoringValidationStatus.success =>
          SignupScreenConstants.referralSuccessText,
        MingoringValidationStatus.error =>
          SignupScreenConstants.referralErrorText,
        MingoringValidationStatus.none => null,
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class SignupNotifier extends _$SignupNotifier {
  @override
  SignupFormState build() => const SignupFormState();

  /// TermsAgreementScreen에서 약관 동의 결과를 저장한다.
  void setTermAgreements(List<bool> agreements) {
    state = state.copyWith(termAgreements: List.unmodifiable(agreements));
  }

  /// 닉네임 입력값을 업데이트하고 유효성을 검증한다.
  void updateNickname(String value) {
    final result = _validateNickname(value);
    state = state.copyWith(
      nicknameInput: value,
      nicknameValidationStatus: result.status,
      nicknameErrorMessage: result.message,
    );
  }

  /// 레벨 선택을 업데이트한다.
  void selectLevel(int index) {
    state = state.copyWith(selectedLevelIndex: index);
  }

  /// 관심 분야 선택을 토글한다.
  void toggleInterest(int index) {
    final updated = Set<int>.from(state.selectedInterestIndexes);
    if (updated.contains(index)) {
      updated.remove(index);
    } else {
      updated.add(index);
    }
    state = state.copyWith(selectedInterestIndexes: updated);
  }

  /// 추천인 코드 입력값을 업데이트하고 검증 상태를 초기화한다.
  void updateReferral(String value) {
    state = state.copyWith(
      referralCodeInput: value,
      referralCodeValidationState: const AsyncValue.data(null),
    );
  }

  /// 추천인 코드 유효성 검증 API를 호출한다.
  /// 결과를 state에 반영한다(AsyncValue 사용).
  Future<void> verifyReferralCode() async {
    final code = state.referralCodeInput;
    if (code.isEmpty) return;
    state =
        state.copyWith(referralCodeValidationState: const AsyncValue.loading());
    final result = await AsyncValue.guard<bool?>(
      () => ref.read(referralRepositoryProvider).verifyReferralCode(code),
    );
    state = state.copyWith(referralCodeValidationState: result);
  }

  /// 회원가입 API를 호출한다.
  ///
  /// UI 입력값을 서버 요청 형식으로 변환해 제출한다.
  /// 성공 시 제출 데이터를 Submit Snapshot에 저장하고 응답을 반환한다.
  /// 실패 시 [submitState]에 에러를 기록하고 null을 반환한다.
  Future<SignupResponseModel?> submit() async {
    state = state.copyWith(submitState: const AsyncValue.loading());

    try {
      final terms = state.termAgreements;
      final interestCodes = state.selectedInterestIndexes
          .map((i) => SignupScreenConstants.interestCodes[i])
          .toList();
      final referralCode =
          state.isReferralVerified ? state.referralCodeInput : null;

      final response = await ref.read(authRepositoryProvider).signup(
            terms: TermsInfoModel(
              termsOfService:
                  terms[TermsAgreementScreenConstants.termsOfServiceIndex],
              privacyPolicy:
                  terms[TermsAgreementScreenConstants.privacyPolicyIndex],
              push: terms[TermsAgreementScreenConstants.pushIndex],
              marketing: terms[TermsAgreementScreenConstants.marketingIndex],
            ),
            nickname: state.nicknameInput,
            level: state.selectedLevelIndex! + 1,
            interests: interestCodes,
            referralCode: referralCode,
          );

      state = state.copyWith(
        submitState: const AsyncValue.data(null),
        nickname: state.nicknameInput,
        level: state.selectedLevelIndex! + 1,
        interestCodes: List.unmodifiable(interestCodes),
        referralCode: referralCode,
        signupResponse: response,
      );

      return response;
    } on AppException catch (e, st) {
      state = state.copyWith(submitState: AsyncValue.error(e, st));
      return null;
    } catch (e, st) {
      state = state.copyWith(
        submitState: AsyncValue.error(const UnknownException(), st),
      );
      return null;
    }
  }

  /// 제출 상태를 초기화한다 (화면 재진입 대비).
  void resetSubmitState() {
    state = state.copyWith(submitState: const AsyncValue.data(null));
  }
}
