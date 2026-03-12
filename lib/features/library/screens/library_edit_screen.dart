import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../models/library_item_model.dart';
import '../providers/library_list_provider.dart';
import '../widgets/library_edit_tab_bar.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';

class LibraryEditScreen extends ConsumerStatefulWidget {
  const LibraryEditScreen({super.key});

  @override
  ConsumerState<LibraryEditScreen> createState() => _LibraryEditScreenState();
}

class _LibraryEditScreenState extends ConsumerState<LibraryEditScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.all;
  final Set<int> _selectedIds = {};
  List<LessonItemModel> _cachedItems = const [];

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;
  static const int _crossAxisCount = 2;

  LibraryListCardStatus _toCardStatus(LessonStatus status) => switch (status) {
        LessonStatus.uploading => LibraryListCardStatus.uploading,
        LessonStatus.inProgress => LibraryListCardStatus.inProgress,
        LessonStatus.completed => LibraryListCardStatus.completed,
      };

  void _toggleSelection(int lessonId) {
    setState(() {
      if (_selectedIds.contains(lessonId)) {
        _selectedIds.remove(lessonId);
      } else {
        _selectedIds.add(lessonId);
      }
    });
  }

  Widget _buildTitleWidget() {
    final count = _selectedIds.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$count',
            style: AppTextStyles.body7B14.copyWith(
              color: AppColors.pink600,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: ' Selected',
            style: AppTextStyles.body9Md14.copyWith(
              color: AppColors.gray600,
              height: 1.2,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final params = LibraryListParams(filter: _selectedFilter);
    final asyncValue = ref.watch(libraryListProvider(params));

    ref.listen(libraryListProvider(params), (_, next) {
      next.whenData((model) {
        setState(() => _cachedItems = model.items);
      });
    });

    final hasSelection = _selectedIds.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MingoringAppBar.actionSave(
        onBack: () => context.pop(),
        titleWidget: _buildTitleWidget(),
        isActionEnabled: hasSelection,
        onActionPressed: () {
          // TODO: save action
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 필터 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: LibraryFilterBar(
                selectedOption: _selectedFilter,
                onSelected: (option) {
                  setState(() => _selectedFilter = option);
                },
              ),
            ),
            const SizedBox(height: 14),

            // 학습 카드 스크롤 영역
            Expanded(child: _buildBody(asyncValue)),
          ],
        ),
      ),
      bottomNavigationBar: LibraryEditTabBar(
        isTrashEnabled: hasSelection,
        isChangeEnabled: hasSelection,
        onTrashTap: hasSelection ? () {} : null,
        onChangeTap: hasSelection ? () {} : null,
      ),
    );
  }

  Widget _buildBody(AsyncValue<LessonListModel> asyncValue) {
    final items = asyncValue.valueOrNull?.items ?? _cachedItems;

    if (asyncValue.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError && items.isEmpty) {
      return Center(
        child: Text(
          'Failed to load library.',
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No lessons found.',
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
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
                .map<Widget>(
                  (item) => LibraryListCard(
                    width: cardWidth,
                    status: _toCardStatus(item.status),
                    title: item.title,
                    videoTime: item.videoTime,
                    thumbnailUrl: item.thumbnailUrl,
                    progressRatio: item.progressRatio,
                    isSelectable: true,
                    isSelected: _selectedIds.contains(item.lessonId),
                    onTap: item.status == LessonStatus.uploading
                        ? null
                        : () => _toggleSelection(item.lessonId),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
