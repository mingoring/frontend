import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/consent_info.dart';
import '../../domain/entities/signup_response.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'signup_viewmodel.g.dart';

// ── DI: SignupUseCase provider (Presentation 계층에서 데이터 계층과 연결) ──────────────

@riverpod
SignupUseCase _signupUseCase(Ref ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
}

// ── ViewModel State ───────────────────────────────────────────────────────────

/// 회원가입 흐름 전체 상태.
/// - [termAgreements]: TermsAgreementScreen에서 설정한 약관 동의 목록.
///   index → [0: termsOfService, 1: privacyPolicy, 2: push, 3: marketing]
/// - [submitState]: 회원가입 API 호출 비동기 상태.
/// - [nickname], [level], [interestCodes]: 제출 성공 후 저장되는 입력 데이터.
/// - [signupResponse]: 제출 성공 후 서버 응답 데이터.
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
  final SignupResponse? signupResponse;

  SignupFormState copyWith({
    List<bool>? termAgreements,
    AsyncValue<void>? submitState,
    String? nickname,
    int? level,
    List<String>? interestCodes,
    SignupResponse? signupResponse,
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

// ── ViewModel ─────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class SignupViewModel extends _$SignupViewModel {
  @override
  SignupFormState build() => const SignupFormState();

  /// TermsAgreementScreen에서 약관 동의 결과를 저장한다.
  /// [agreements] 순서: [termsOfService, privacyPolicy, push, marketing]
  void setTermAgreements(List<bool> agreements) {
    state = state.copyWith(termAgreements: List.unmodifiable(agreements));
  }

  /// 회원가입 API를 호출한다.
  ///
  /// - [nickname]: 닉네임 (최대 10자, 한/영)
  /// - [level]: 레벨 1~5 (SignupScreen의 0-based index + 1)
  /// - [interestCodes]: 관심분야 코드 리스트 (예: ['K_POP', 'TRAVEL'])
  ///
  /// 성공 시 입력값과 서버 응답을 state에 저장하고 [SignupResponse]를 반환한다.
  Future<SignupResponse?> submit({
    required String nickname,
    required int level,
    required List<String> interestCodes,
  }) async {
    state = state.copyWith(submitState: const AsyncValue.loading());

    try {
      final useCase = ref.read(_signupUseCaseProvider);
      final terms = state.termAgreements;

      final response = await useCase(
        termsOfService: ConsentInfo(agreed: terms[0]),
        privacyPolicy: ConsentInfo(agreed: terms[1]),
        push: ConsentInfo(agreed: terms[2]),
        marketing: ConsentInfo(agreed: terms[3]),
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
