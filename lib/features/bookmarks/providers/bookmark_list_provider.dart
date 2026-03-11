import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/models/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../constants/bookmark_constants.dart';
import '../models/bookmark_item_model.dart';
import '../repositories/bookmark_repository.dart';

/// 북마크 목록 조회 파라미터
class BookmarkListParams {
  const BookmarkListParams({
    required this.sort,
    this.keyword,
  });

  final BookmarkSortType sort;
  final String? keyword;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkListParams &&
          runtimeType == other.runtimeType &&
          sort == other.sort &&
          keyword == other.keyword;

  @override
  int get hashCode => Object.hash(sort, keyword);
}

final bookmarkListProvider =
    FutureProvider.autoDispose.family<BookmarkListModel, BookmarkListParams>(
        (ref, params) async {
  final authState = ref.watch(authNotifierProvider);

  if (authState is! AuthStateAuthenticated) {
    return const BookmarkListModel.empty();
  }

  final repository = ref.watch(bookmarkRepositoryProvider);
  try {
    return repository.fetchList(
      sort: params.sort,
      keyword: params.keyword,
    );
  } on UnauthorizedException {
    return const BookmarkListModel.empty();
  }
});
