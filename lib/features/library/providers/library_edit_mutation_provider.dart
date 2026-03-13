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

  /// status change 먼저 (status별 그룹 → 순차 호출), 이후 delete (동기 순차)
  Future<bool> saveAll({
    required Map<int, LessonStatus> statusChanges,
    required List<int> deleteIds,
  }) async {
    if (statusChanges.isEmpty && deleteIds.isEmpty) {
      state = const AsyncValue.data(null);
      return true;
    }

    state = const AsyncValue.loading();
    try {
      if (deleteIds.isNotEmpty) {
        await _repository.deleteVideos(lessonIds: deleteIds);
      }

      final remainingStatusChanges = {
        for (final entry in statusChanges.entries)
          if (!deleteIds.contains(entry.key)) entry.key: entry.value,
      };

      if (remainingStatusChanges.isNotEmpty) {
        final grouped = <LessonStatus, List<int>>{};
        for (final entry in remainingStatusChanges.entries) {
          grouped.putIfAbsent(entry.value, () => []).add(entry.key);
        }
        for (final entry in grouped.entries) {
          await _repository.updateStatus(
            lessonIds: entry.value,
            status: entry.key,
          );
        }
      }
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
