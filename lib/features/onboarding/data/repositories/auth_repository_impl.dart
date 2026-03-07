import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/consent_info.dart';
import '../../domain/entities/signup_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/consent_info_model.dart';
import '../models/signup_request_model.dart';
import '../models/signup_response_model.dart';

part 'auth_repository_impl.g.dart';

/// [AuthRepository] 구현체.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<SignupResponse> signup({
    required ConsentInfo termsOfService,
    required ConsentInfo privacyPolicy,
    required ConsentInfo push,
    required ConsentInfo marketing,
    required String nickname,
    required int level,
    required List<String> interests,
  }) async {
    final request = SignupRequestModel(
      termsOfService: ConsentInfoModel.fromDomain(termsOfService),
      privacyPolicy: ConsentInfoModel.fromDomain(privacyPolicy),
      push: ConsentInfoModel.fromDomain(push),
      marketing: ConsentInfoModel.fromDomain(marketing),
      nickname: nickname,
      level: level,
      interests: interests,
    );
    final response = await _remoteDataSource.signup(request);
    return response.toDomain();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}
