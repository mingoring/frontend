import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../repositories/library_repository.dart';

/// 영상 추가 뮤테이션 상태 관리
///
/// State 의미:
///   AsyncData(null)   → idle / 성공
///   AsyncLoading()    → 요청 진행 중
///   AsyncError(e, st) → 요청 실패
class LibraryAddVideoNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  LibraryRepository get _repository => ref.read(libraryRepositoryProvider);

  Future<void> addVideo(String url) async {
    state = const AsyncValue.loading();

    try {
      await _repository.addVideo(url: url);
      state = const AsyncValue.data(null);
    } on AppException catch (e, st) {
      state = AsyncValue.error(e, st);
    } catch (e, st) {
      state = AsyncValue.error(const UnknownException(), st);
    }
  }
}

final libraryAddVideoProvider =
    NotifierProvider.autoDispose<LibraryAddVideoNotifier, AsyncValue<void>>(
      LibraryAddVideoNotifier.new,
    );
