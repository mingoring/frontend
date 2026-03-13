import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../constants/library_constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../models/library_edit_screen_args.dart';
import '../models/library_item_model.dart';
import '../providers/library_edit_mutation_provider.dart';
import '../providers/library_list_provider.dart';
import '../widgets/library_delete_bottom_sheet.dart';
import '../widgets/library_edit_action_bar.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';
import '../widgets/library_status_change_bottom_sheet.dart';

class LibraryEditScreen extends ConsumerStatefulWidget {
  const LibraryEditScreen({
    super.key,
    required this.args,
  });

  final LibraryEditScreenArgs args;

  @override
  ConsumerState<LibraryEditScreen> createState() => _LibraryEditScreenState();
}

class _LibraryEditScreenState extends ConsumerState<LibraryEditScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.inProgress;
  final Map<LibraryFilterOption, Set<int>> _selectionByFilter = {};

  Set<int> get _currentSelection =>
      _selectionByFilter.putIfAbsent(_selectedFilter, () => {});

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;
  static const int _crossAxisCount = 2;

  bool _matchesFilter(LessonStatus status) => switch (_selectedFilter) {
        LibraryFilterOption.all => true,
        LibraryFilterOption.uploading => status == LessonStatus.uploading,
        LibraryFilterOption.inProgress => status == LessonStatus.inProgress,
        LibraryFilterOption.completed => status == LessonStatus.completed,
      };

  void _toggleSelection(int lessonId) {
    setState(() {
      if (_currentSelection.contains(lessonId)) {
        _currentSelection.remove(lessonId);
      } else {
        _currentSelection.add(lessonId);
      }
    });
  }

  LessonStatus _toModelStatus(LibraryVideoStatus v) => switch (v) {
        LibraryVideoStatus.inProgress => LessonStatus.inProgress,
        LibraryVideoStatus.completed => LessonStatus.completed,
      };

  Future<void> _onTrashTap() async {
    final ids = _currentSelection.toList(growable: false);
    bool confirmed = false;

    await LibraryDeleteBottomSheet.show(
      context,
      onDelete: () => confirmed = true,
    );
    if (!mounted || !confirmed) return;

    final success = await ref
        .read(libraryEditMutationProvider.notifier)
        .deleteVideos(ids);
    if (!mounted) return;

    if (success) {
      ref.invalidate(libraryListProvider);
      setState(() => _selectionByFilter.remove(_selectedFilter));
    } else {
      final error = ref.read(libraryEditMutationProvider).error;
      ErrorAlertDialog.show(
        context,
        errorMessage: error is AppException ? error.message : null,
      );
    }
  }

  Future<void> _onChangeTap() async {
    final ids = _currentSelection.toList(growable: false);
    LessonStatus? chosen;

    await LibraryStatusChangeBottomSheet.show(
      context,
      currentFilter: _selectedFilter,
      onStatusChanged: (v) => chosen = _toModelStatus(v),
    );
    if (!mounted || chosen == null) return;

    final success = await ref
        .read(libraryEditMutationProvider.notifier)
        .updateStatus(ids, chosen!);
    if (!mounted) return;

    if (success) {
      ref.invalidate(libraryListProvider);
      setState(() => _selectionByFilter.remove(_selectedFilter));
    } else {
      final error = ref.read(libraryEditMutationProvider).error;
      ErrorAlertDialog.show(
        context,
        errorMessage: error is AppException ? error.message : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItemsAsync = ref.watch(
      libraryListProvider(const LibraryListParams(filter: LibraryFilterOption.all)),
    );
    final isMutating = ref.watch(libraryEditMutationProvider).isLoading;
    final currentSelection = _selectionByFilter[_selectedFilter] ?? const <int>{};
    final hasSelection = currentSelection.isNotEmpty && !isMutating;
    final allItems = allItemsAsync.valueOrNull?.items ?? const <LessonItemModel>[];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MingoringAppBar(
        onBack: () => context.pop(),
        type: MingoringBackHeaderType.title,
        titleWidget: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${currentSelection.length}',
                style: AppTextStyles.body7B14.copyWith(
                  color: AppColors.pink600,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: ' Selected',
                style: AppTextStyles.body7B14.copyWith(
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: LibraryFilterBar(
                selectedOption: _selectedFilter,
                onSelected: (option) {
                  setState(() {
                    _selectionByFilter.remove(_selectedFilter);
                    _selectedFilter = option;
                  });
                },
                editableOnly: true,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(child: _buildBody(allItemsAsync, allItems, currentSelection)),
          ],
        ),
      ),
      bottomNavigationBar: LibraryEditActionBar(
        isTrashEnabled: hasSelection,
        isChangeEnabled: hasSelection,
        onTrashTap: hasSelection ? _onTrashTap : null,
        onChangeTap: hasSelection ? _onChangeTap : null,
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<LessonListModel> asyncValue,
    List<LessonItemModel> allItems,
    Set<int> currentSelection,
  ) {
    if (asyncValue.isLoading && allItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError && allItems.isEmpty) {
      return Center(
        child: Text(
          LibraryConstants.loadErrorMessage,
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
    }

    final visibleItems =
        allItems.where((item) => _matchesFilter(item.status)).toList();

    if (visibleItems.isEmpty) {
      return Center(
        child: Text(
          LibraryConstants.editEmptyMessage,
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
            children: visibleItems.map<Widget>((item) {
              return LibraryListCard(
                width: cardWidth,
                status: item.status.toCardStatus(),
                title: item.title,
                videoTime: item.videoTime,
                thumbnailUrl: item.thumbnailUrl,
                progressRatio: item.progressRatio,
                isSelectable: true,
                isSelected: currentSelection.contains(item.lessonId),
                onTap: item.status == LessonStatus.uploading
                    ? null
                    : () => _toggleSelection(item.lessonId),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
