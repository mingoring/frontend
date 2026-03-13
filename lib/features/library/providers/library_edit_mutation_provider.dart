import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../models/library_item_model.dart';
import '../repositories/library_repository.dart';

/// delete / status-change 뮤테이션 상태 관리
///
/// State 의미:
///   AsyncData(null)   → idle / 성공
///   AsyncLoading()    → 요청 진행 중
///   AsyncError(e, st) → 요청 실패
class LibraryEditMutationNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  LibraryRepository get _repository => ref.read(libraryRepositoryProvider);

  Future<bool> deleteVideos(List<int> lessonIds) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteVideos(lessonIds: lessonIds);
      state = const AsyncValue.data(null);
      return true;
    } on AppException catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(const UnknownException(), st);
      return false;
    }
  }

  Future<bool> updateStatus(List<int> lessonIds, LessonStatus status) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateStatus(lessonIds: lessonIds, status: status);
      state = const AsyncValue.data(null);
      return true;
    } on AppException catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(const UnknownException(), st);
      return false;
    }
  }

}

final libraryEditMutationProvider =
    NotifierProvider.autoDispose<LibraryEditMutationNotifier, AsyncValue<void>>(
  LibraryEditMutationNotifier.new,
);
