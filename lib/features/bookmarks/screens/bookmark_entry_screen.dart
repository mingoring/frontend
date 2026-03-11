import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/indicators/mingoring_circular_progress_indicator.dart';
import '../providers/bookmark_stats_provider.dart';
import 'bookmark_empty_screen.dart';
import 'bookmark_screen.dart';

/// 북마크 카운트에 따라 [BookmarkEmptyScreen] 또는 [BookmarkScreen]으로 분기한다.
///
/// 에러 발생 시 호출 측(HomeScreen)으로 에러를 반환하며 pop한다.
/// - [ref.listen]: loading → error 전환 감지
/// - [initState]: 이미 에러 상태로 진입한 경우 처리 (ref.listen은 전환이 없으면 발화하지 않음)
class BookmarkEntryScreen extends ConsumerStatefulWidget {
  const BookmarkEntryScreen({super.key});

  @override
  ConsumerState<BookmarkEntryScreen> createState() =>
      _BookmarkEntryScreenState();
}

class _BookmarkEntryScreenState extends ConsumerState<BookmarkEntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(bookmarkStatsProvider);
      if (state is AsyncError && context.canPop()) {
        context.pop(state.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      bookmarkStatsProvider,
      (prev, next) {
        if (prev is! AsyncError && next is AsyncError && context.canPop()) {
          context.pop(next.error);
        }
      },
    );

    return ref.watch(bookmarkStatsProvider).when(
          data: (stats) {
            if (stats.count == 0) {
              return const BookmarkEmptyScreen();
            }

            return const BookmarkScreen();
          },
          loading: () => const Scaffold(
            body: Center(child: MingoringCircularProgressIndicator()),
          ),
          error: (_, __) => const Scaffold(body: SizedBox.shrink()),
        );
  }
}
