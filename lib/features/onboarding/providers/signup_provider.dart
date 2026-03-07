import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../models/terms_info_model.dart';
import '../models/signup_response_model.dart';
import '../repositories/auth_repository.dart';

part 'signup_provider.g.dart';

// ── ViewModel State ───────────────────────────────────────────────────────────

/// 회원가입 흐름 전체 상태.
/// - [termAgreements]: 약관 동의 목록.
///   index → [0: termsOfService, 1: privacyPolicy, 2: push, 3: marketing]
/// - [submitState]: 회원가입 API 호출 비동기 상태.
/// - [nickname], [level], [interestCodes]: 제출 성공 후 저장되는 입력 데이터.
/// - [signupResponse]: 회원가입 성공 응답 데이터.
class SignupFormState {
  const SignupFormState({
    this.termAgreements = const [false, false, false, false],
    this.submitState = const AsyncValue.data(null),
    this.nickname,
    this.level,
    this.interestCodes,
    this.signupResponse,
  });

  final List<bool> termAgreements;
  final AsyncValue<void> submitState;

  /// 회원가입 성공 후 채워지는 필드들
  final String? nickname;
  final int? level;
  final List<String>? interestCodes;
  final SignupResponseModel? signupResponse;

  SignupFormState copyWith({
    List<bool>? termAgreements,
    AsyncValue<void>? submitState,
    String? nickname,
    int? level,
    List<String>? interestCodes,
    SignupResponseModel? signupResponse,
  }) {
    return SignupFormState(
      termAgreements: termAgreements ?? this.termAgreements,
      submitState: submitState ?? this.submitState,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      interestCodes: interestCodes ?? this.interestCodes,
      signupResponse: signupResponse ?? this.signupResponse,
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class SignupNotifier extends _$SignupNotifier {
  @override
  SignupFormState build() => const SignupFormState();

  /// TermsAgreementScreen에서 약관 동의 결과를 저장한다.
  /// [agreements] 순서: [termsOfService, privacyPolicy, push, marketing]
  void setTermAgreements(List<bool> agreements) {
    state = state.copyWith(termAgreements: List.unmodifiable(agreements));
  }

  /// 회원가입 API를 호출한다.
  ///
  /// - [nickname]: 닉네임
  /// - [level]: 레벨 1~5 (SignupScreen의 0-based index + 1)
  /// - [interestCodes]: 관심분야 코드 리스트
  ///
  /// 성공 시 입력값과 서버 응답을 state에 저장하고 [SignupResponseModel]을 반환한다.
  Future<SignupResponseModel?> submit({
    required String nickname,
    required int level,
    required List<String> interestCodes,
  }) async {
    state = state.copyWith(submitState: const AsyncValue.loading());

    try {
      final terms = state.termAgreements;
      final response = await ref.read(authRepositoryProvider).signup(
            terms: TermsInfoModel(
              termsOfService: terms[0],
              privacyPolicy: terms[1],
              push: terms[2],
              marketing: terms[3],
            ),
            nickname: nickname,
            level: level,
            interests: interestCodes,
          );

      state = state.copyWith(
        submitState: const AsyncValue.data(null),
        nickname: nickname,
        level: level,
        interestCodes: List.unmodifiable(interestCodes),
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
