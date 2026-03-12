import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/video_uploading_alert_dialog.dart';
import '../../../core/widgets/dialogs/video_watch_alert_dialog.dart';
import '../constants/library_constants.dart';
import '../models/library_edit_screen_args.dart';
import '../models/library_item_model.dart';
import '../providers/library_list_provider.dart';
import '../widgets/library_add_video_button.dart';
import '../widgets/library_input_link_bottom_sheet.dart';
import '../widgets/library_edit_button.dart';
import '../widgets/library_empty_section.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.all;

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;
  static const int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final visibleParams = LibraryListParams(filter: _selectedFilter);
    final visibleAsyncValue = ref.watch(libraryListProvider(visibleParams));

    /// 편집 화면에서는 필터 변경을 자유롭게 해야 하므로,
    /// 현재 선택된 필터 목록이 아니라 전체 목록 스냅샷을 따로 확보한다.
    final allParams = const LibraryListParams(filter: LibraryFilterOption.all);
    final allItemsAsyncValue = ref.watch(libraryListProvider(allParams));

    final visibleItems = visibleAsyncValue.valueOrNull?.items ?? const <LessonItemModel>[];
    final allItemsForEdit = allItemsAsyncValue.valueOrNull?.items ?? const <LessonItemModel>[];

    return Scaffold(
      backgroundColor: AppColors.pink100,
      floatingActionButton: LibraryAddVideoButton(
        onTap: () => LibraryInputLinkBottomSheet.show(context),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Library 타이틀 + Edit 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          LibraryConstants.screenTitle,
                          style: AppLogoTypography.logoB4.copyWith(
                            color: AppColors.pink600,
                          ),
                        ),
                        const Spacer(),
                        LibraryEditButton(
                          enabled: allItemsForEdit.isNotEmpty,
                          onTap: () async {
                            final saved = await context.push<bool>(
                              RouteNames.libraryEdit,
                              extra: LibraryEditScreenArgs(
                                initialItems: allItemsForEdit,
                                initialFilter: _selectedFilter,
                              ),
                            );
                            if (!mounted) return;

                            if (saved == true) {
                              ref.invalidate(libraryListProvider);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 서브타이틀
                  Text(
                    LibraryConstants.screenSubtitle,
                    style: AppTextStyles.body8Sb14.copyWith(
                      color: AppColors.gray500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 필터 바
                  LibraryFilterBar(
                    selectedOption: _selectedFilter,
                    onSelected: (option) {
                      setState(() => _selectedFilter = option);
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // 카드 그리드 (2열 고정)
            Expanded(
              child: _buildBody(visibleAsyncValue, visibleItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<LessonListModel> asyncValue,
    List<LessonItemModel> items,
  ) {
    if (asyncValue.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError && items.isEmpty) {
      debugPrint('[LibraryScreen] error: ${asyncValue.error}');
      debugPrint('[LibraryScreen] stackTrace: ${asyncValue.stackTrace}');
      return Center(
        child: Text(
          LibraryConstants.loadErrorMessage,
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
    }

    if (items.isEmpty) {
      return const LibraryEmptySection();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - (_horizontalPadding * 2);
        final cardWidth =
            (contentWidth - (_cardSpacing * (_crossAxisCount - 1))) /
                _crossAxisCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            _horizontalPadding,
            5,
            _horizontalPadding,
            24,
          ),
          child: Wrap(
            spacing: _cardSpacing,
            runSpacing: _cardSpacing,
            children: items
                .map(
                  (item) => LibraryListCard(
                    width: cardWidth,
                    status: item.status.toCardStatus(),
                    title: item.title,
                    videoTime: item.videoTime,
                    thumbnailUrl: item.thumbnailUrl,
                    progressRatio: item.progressRatio,
                    onTap: switch (item.status) {
                      LessonStatus.uploading =>
                        () => VideoUploadingAlertDialog.show(context),
                      LessonStatus.inProgress || LessonStatus.completed =>
                        () => VideoWatchAlertDialog.show(
                              context,
                              videoTitle: item.title,
                              originalText: item.originalText,
                              translatedText: item.translatedText,
                            ),
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
