import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/models/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/library_item_model.dart';
import '../repositories/library_repository.dart';
import '../models/library_filter_option.dart';

/// 라이브러리 목록 조회 파라미터
class LibraryListParams {
  const LibraryListParams({required this.filter});

  final LibraryFilterOption filter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryListParams &&
          runtimeType == other.runtimeType &&
          filter == other.filter;

  @override
  int get hashCode => filter.hashCode;
}

final libraryListProvider = FutureProvider.autoDispose
    .family<LessonListModel, LibraryListParams>((ref, params) async {
  final authState = ref.watch(authNotifierProvider);

  if (authState is! AuthStateAuthenticated) {
    return const LessonListModel.empty();
  }

  try {
    return await ref
        .watch(libraryRepositoryProvider)
        .fetchList(filter: params.filter);
  } on UnauthorizedException {
    return const LessonListModel.empty();
  }
});
