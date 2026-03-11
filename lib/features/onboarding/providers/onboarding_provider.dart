import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/local_storage_service.dart';

part 'onboarding_provider.g.dart';

/// 온보딩 완료 여부를 관리하는 provider.
/// 인증 없을 때 redirect 목적지를 결정하는 용도로만 사용된다.
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    Future.microtask(_init);
    return false;
  }

  Future<void> _init() async {
    try {
      final localStorage = await ref.read(localStorageServiceProvider.future);
      state = localStorage.isOnboardingFlagSet();
    } catch (_) {
      state = false;
    }
  }

  Future<void> completeOnboarding() async {
    final localStorage = await ref.read(localStorageServiceProvider.future);
    await localStorage.saveOnboardingFlag();
  }
}
