import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage_service.dart';
import '../constants/bookmark_constants.dart';

final bookmarkSortNotifierProvider =
    AsyncNotifierProvider<BookmarkSortNotifier, BookmarkSortType>(
        BookmarkSortNotifier.new);

class BookmarkSortNotifier extends AsyncNotifier<BookmarkSortType> {
  @override
  Future<BookmarkSortType> build() async {
    final storage = await ref.watch(localStorageServiceProvider.future);
    final stored = storage.getBookmarkSort();
    return BookmarkSortType.values.firstWhere(
      (e) => e.apiValue == stored,
      orElse: () => BookmarkSortType.newest,
    );
  }

  Future<void> setSortType(BookmarkSortType sort) async {
    final storage = await ref.read(localStorageServiceProvider.future);
    await storage.saveBookmarkSort(sort.apiValue);
    state = AsyncData(sort);
  }
}
