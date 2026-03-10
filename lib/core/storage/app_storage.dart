import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_storage_service.dart';
import 'memory_cache_service.dart';

final appStorageProvider = FutureProvider<AppStorage>((ref) async {
  final localStorageService =
      await ref.watch(localStorageServiceProvider.future);
  final memoryCacheService = ref.watch(memoryCacheServiceProvider);
  return AppStorage(
    localStorageService: localStorageService,
    memoryCacheService: memoryCacheService,
  );
});

class AppStorage {
  const AppStorage({
    required LocalStorageService localStorageService,
    required MemoryCacheService memoryCacheService,
  })  : _localStorageService = localStorageService,
        _memoryCacheService = memoryCacheService;

  final LocalStorageService _localStorageService;
  final MemoryCacheService _memoryCacheService;

  /// 저장된 로컬 데이터를 모두 정리한다.
  Future<void> clearAll() async {
    await _localStorageService.clearSessionAll();
    await _memoryCacheService.clearCacheAll();
  }

  /// 로그인 사용자와 직접 관련된 데이터만 정리한다.
  Future<void> clearLoginData() async {
    await _localStorageService.clearLoginData();
    await _memoryCacheService.clearLoginData();
  }
}
