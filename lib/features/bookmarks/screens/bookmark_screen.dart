import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/inputs/mingoring_dropdown_menu_small.dart';
import '../../../core/widgets/toasts/mingoring_toast.dart';
import '../../../core/widgets/inputs/mingoring_text_field_search.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../constants/bookmark_constants.dart';
import '../models/bookmark_item_model.dart';
import '../providers/bookmark_list_provider.dart';
import '../providers/bookmark_sort_provider.dart';
import '../providers/bookmark_tts_provider.dart';
import '../widgets/bookmark_card.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  static const _horizontalPadding = 16.5;
  static const _subtitleToSearchSpacing = 18.0;
  static const _searchToCountSpacing = 16.0;
  static const _countToListSpacing = 8.0;
  static const _cardSpacing = 7.0;
  static const _listBottomPadding = 32.0;

  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  String _keyword = '';
  int _bookmarkCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSortChanged(String value) {
    final selected = BookmarkSortType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => BookmarkSortType.newest,
    );
    ref.read(bookmarkSortNotifierProvider.notifier).setSortType(selected);
  }

  void _onSearchSubmitted(String value) {
    FocusScope.of(context).unfocus();
    setState(() => _keyword = value);
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty && _keyword.isNotEmpty) {
      setState(() => _keyword = '');
    }
  }

  void _toggleTts(int bookmarkId, String text) {
    ref.read(bookmarkTtsProvider.notifier).toggle(bookmarkId, text);
  }

  @override
  Widget build(BuildContext context) {
    final sortAsync = ref.watch(bookmarkSortNotifierProvider);
    final effectiveSort = sortAsync.valueOrNull ?? BookmarkSortType.newest;

    final params = BookmarkListParams(
      sort: effectiveSort,
      keyword: _keyword.isEmpty ? null : _keyword,
    );

    ref.listen<AsyncValue<BookmarkListModel>>(
      bookmarkListProvider(params),
      (prev, next) {
        next.whenOrNull(
          data: (data) {
            if (_bookmarkCount != data.totalItems) {
              setState(() => _bookmarkCount = data.totalItems);
            }
          },
          error: (e, _) {
            if (prev is! AsyncError) {
              if (e is AppException) {
                ErrorAlertDialog.show(context, errorMessage: e.message);
              } else {
                ErrorAlertDialog.show(context);
              }
            }
          },
        );
      },
    );

    final playingBookmarkId = ref.watch(bookmarkTtsProvider);
    final listAsync = ref.watch(bookmarkListProvider(params));
    final items = listAsync.valueOrNull?.items ?? [];
    final displayCount = listAsync.valueOrNull?.totalItems ?? _bookmarkCount;

    return Scaffold(
      backgroundColor: AppColors.pink50,
      appBar: MingoringAppBar(
        type: MingoringBackHeaderType.none,
        onBack: () => context.pop(),
        backgroundColor: AppColors.pink50,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleSection(),
              const SizedBox(height: _subtitleToSearchSpacing),
              MingoringTextFieldSearch(
                controller: _searchController,
                hintText: BookmarkConstants.searchHint,
                focusNode: _searchFocusNode,
                onSubmitted: _onSearchSubmitted,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: _searchToCountSpacing),
              _CountAndSortBar(
                count: displayCount,
                sort: effectiveSort,
                onSortChanged: _onSortChanged,
              ),
              const SizedBox(height: _countToListSpacing),
              Expanded(
                child: listAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.pink600,
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (_) => ListView.separated(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom +
                          _listBottomPadding,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: _cardSpacing),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isPlaying = playingBookmarkId == item.bookmarkId;
                      return BookmarkCard(
                        originalText: item.originalText,
                        translatedText: item.translatedText,
                        type: isPlaying
                            ? BookmarkCardState.playing
                            : BookmarkCardState.idle,
                        onTap: () =>
                            _toggleTts(item.bookmarkId, item.originalText),
                        onWatchPressed: () => MingoringToast.show(
                          context,
                          message:
                              'learningCardId: ${item.learningCardId}, lessonId: ${item.lessonId} 클릭됨!',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          BookmarkConstants.screenTitle,
          style: AppLogoTypography.logoB4.copyWith(
            color: AppColors.pink600,
          ),
        ),
        const SizedBox(height: _gap),
        Text(
          BookmarkConstants.screenSubtitle,
          style: AppTextStyles.body5Sb15.copyWith(
            color: AppColors.gray500,
          ),
        ),
      ],
    );
  }
}

class _CountAndSortBar extends StatelessWidget {
  const _CountAndSortBar({
    required this.count,
    required this.sort,
    required this.onSortChanged,
  });

  final int count;
  final BookmarkSortType sort;
  final ValueChanged<String> onSortChanged;

  static const _sortOptions = [
    InputSelectionOption(label: 'Newest', value: 'NEWEST'),
    InputSelectionOption(label: 'Oldest', value: 'OLDEST'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: AppTextStyles.body8Sb14.copyWith(
                color: AppColors.pink600,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              BookmarkConstants.bookmarkCountSuffix,
              style: AppTextStyles.body9Md14.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
        MingoringDropdownMenuSmall(
          options: _sortOptions,
          value: sort.apiValue,
          onChanged: onSortChanged,
        ),
      ],
    );
  }
}
