import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated({required String accessToken}) =
      AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.guest() = AuthStateGuest;
}
