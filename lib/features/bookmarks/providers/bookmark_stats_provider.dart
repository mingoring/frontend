import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/models/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/bookmark_stats_model.dart';
import '../repositories/bookmark_repository.dart';

final bookmarkStatsProvider = FutureProvider<BookmarkStatsModel>((ref) async {
  final authState = ref.watch(authNotifierProvider);

  if (authState is! AuthStateAuthenticated) {
    return const BookmarkStatsModel.empty();
  }

  final repository = ref.watch(bookmarkRepositoryProvider);
  try {
    return repository.fetchStats();
  } on UnauthorizedException {
    return const BookmarkStatsModel.empty();
  }
});
