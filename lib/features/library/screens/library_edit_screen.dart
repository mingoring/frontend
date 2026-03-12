import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../models/library_item_model.dart';
import '../providers/library_edit_mutation_provider.dart';
import '../providers/library_list_provider.dart';
import '../widgets/library_delete_bottom_sheet.dart';
import '../widgets/library_edit_action_bar.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';
import '../widgets/library_status_change_bottom_sheet.dart';

class LibraryEditScreen extends ConsumerStatefulWidget {
  const LibraryEditScreen({super.key});

  @override
  ConsumerState<LibraryEditScreen> createState() => _LibraryEditScreenState();
}

class _LibraryEditScreenState extends ConsumerState<LibraryEditScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.all;
  final Set<int> _selectedIds = {};
  List<LessonItemModel> _cachedItems = const [];

  /// 백엔드에 아직 보내지 않은 pending 상태 변경 (Save 시 전송)
  /// 원본 _cachedItems와 분리하되, 화면 표시에는 반영한다.
  final Map<int, LessonStatus> _pendingStatusChanges = {};
  final Set<int> _pendingDeletes = {};

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;
  static const int _crossAxisCount = 2;

  LibraryListCardStatus _toCardStatus(LessonStatus status) => switch (status) {
        LessonStatus.uploading => LibraryListCardStatus.uploading,
        LessonStatus.inProgress => LibraryListCardStatus.inProgress,
        LessonStatus.completed => LibraryListCardStatus.completed,
      };

  LessonStatus _effectiveStatusOf(LessonItemModel item) {
    return _pendingStatusChanges[item.lessonId] ?? item.status;
  }

  List<LessonItemModel> _buildVisibleItems(List<LessonItemModel> source) {
    return source
        .where((item) => !_pendingDeletes.contains(item.lessonId))
        .toList();
  }

  void _toggleSelection(int lessonId) {
    if (_pendingDeletes.contains(lessonId)) return;

    setState(() {
      if (_selectedIds.contains(lessonId)) {
        _selectedIds.remove(lessonId);
      } else {
        _selectedIds.add(lessonId);
      }
    });
  }

  LibraryVideoStatus get _currentStatusForSheet {
    final selected = _cachedItems.where(
      (item) =>
          _selectedIds.contains(item.lessonId) &&
          !_pendingDeletes.contains(item.lessonId),
    );

    final allCompleted = selected.isNotEmpty &&
        selected.every(
          (item) => _effectiveStatusOf(item) == LessonStatus.completed,
        );

    return allCompleted
        ? LibraryVideoStatus.completed
        : LibraryVideoStatus.inProgress;
  }

  LessonStatus _toModelStatus(LibraryVideoStatus v) => switch (v) {
        LibraryVideoStatus.inProgress => LessonStatus.inProgress,
        LibraryVideoStatus.completed => LessonStatus.completed,
      };

  /// 삭제 확인 → pending에 저장 (API 즉시 호출 X) 
  Future<void> _onTrashTap() async {
    final ids = _selectedIds.toList();
    bool confirmed = false;

    await LibraryDeleteBottomSheet.show(
      context,
      onDelete: () {
        confirmed = true;
      },
    );
    if (!mounted || !confirmed) return;

    setState(() {
      _pendingDeletes.addAll(ids);

      for (final id in ids) {
        _pendingStatusChanges.remove(id);
      }

      _selectedIds.clear();
    });
  }

  /// 상태 변경 선택 → pending에 저장 (API 즉시 호출 X)
  Future<void> _onChangeTap() async {
    final ids = _selectedIds.toList();
    LessonStatus? chosen;

    await LibraryStatusChangeBottomSheet.show(
      context,
      currentStatus: _currentStatusForSheet,
      onStatusChanged: (v) {
        chosen = _toModelStatus(v);
      },
    );
    if (!mounted || chosen == null) return;

    setState(() {
      for (final id in ids) {
        if (_pendingDeletes.contains(id)) continue;
        _pendingStatusChanges[id] = chosen!;
      }
      _selectedIds.clear();
    });
  }

  Future<void> _onSave() async {
    final success = await ref.read(libraryEditMutationProvider.notifier).saveAll(
          statusChanges: Map.of(_pendingStatusChanges),
          deleteIds: _pendingDeletes.toList(),
        );
    if (!mounted) return;

    if (success) {
      context.pop(true);
    } else {
      final error = ref.read(libraryEditMutationProvider).error;
      ErrorAlertDialog.show(
        context,
        errorMessage: error is AppException ? error.message : null,
      );
    }
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
        setState(() {
          _cachedItems = model.items;
        });
      });
    });

    final isMutating = ref.watch(libraryEditMutationProvider).isLoading;

    final hasPendingChanges =
        (_pendingStatusChanges.isNotEmpty || _pendingDeletes.isNotEmpty) &&
            !isMutating;

    final hasSelection = _selectedIds.isNotEmpty && !isMutating;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MingoringAppBar.actionSave(
        onBack: () => context.pop(),
        titleWidget: _buildTitleWidget(),
        isActionEnabled: hasPendingChanges,
        onActionPressed: _onSave,
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
      bottomNavigationBar: LibraryEditActionBar(
        isTrashEnabled: hasSelection,
        isChangeEnabled: hasSelection,
        onTrashTap: hasSelection ? _onTrashTap : null,
        onChangeTap: hasSelection ? _onChangeTap : null,
      ),
    );
  }

  Widget _buildBody(AsyncValue<LessonListModel> asyncValue) {
    final sourceItems = asyncValue.valueOrNull?.items ?? _cachedItems;
    final items = _buildVisibleItems(sourceItems);

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
            children: items.map<Widget>((item) {
              final effectiveStatus = _effectiveStatusOf(item);

              return LibraryListCard(
                width: cardWidth,
                status: _toCardStatus(effectiveStatus),
                title: item.title,
                videoTime: item.videoTime,
                thumbnailUrl: item.thumbnailUrl,
                progressRatio: item.progressRatio,
                isSelectable: true,
                isSelected: _selectedIds.contains(item.lessonId),
                onTap: effectiveStatus == LessonStatus.uploading
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
