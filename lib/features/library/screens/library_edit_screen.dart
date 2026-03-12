import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../constants/library_constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dialogs/confirm_alert_dialog.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../models/library_edit_screen_args.dart';
import '../models/library_item_model.dart';
import '../providers/library_edit_mutation_provider.dart';
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
  late LibraryFilterOption _selectedFilter;
  final Set<int> _selectedIds = {};

  /// 편집 화면 진입 시점의 원본 스냅샷
  ///
  /// Save 시 draft와 비교할 기준 데이터다.
  late final Map<int, LessonItemModel> _originalItemsById;

  /// 카드 노출 순서를 원본과 동일하게 유지하기 위한 lessonId 순서 목록
  late final List<int> _initialOrderLessonIds;

  /// 편집 화면 전용 draft 상태값
  ///
  /// 화면 표시와 필터 판별은 모두 이 값을 기준으로 계산한다.
  late final Map<int, LessonStatus> _draftStatusesById;

  /// 편집 화면 전용 draft 삭제 상태
  ///
  /// 아직 백엔드에는 반영되지 않았으며, Save 시 delete payload로 전송된다.
  final Set<int> _draftDeletedIds = {};

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;
  static const int _crossAxisCount = 2;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.args.initialFilter;

    _originalItemsById = {
      for (final item in widget.args.initialItems) item.lessonId: item,
    };

    _initialOrderLessonIds = widget.args.initialItems
        .map((item) => item.lessonId)
        .toList(growable: false);

    _draftStatusesById = {
      for (final item in widget.args.initialItems) item.lessonId: item.status,
    };
  }

  bool get _hasUnsavedChanges {
    if (_draftDeletedIds.isNotEmpty) return true;

    for (final lessonId in _initialOrderLessonIds) {
      final original = _originalItemsById[lessonId];
      final draftStatus = _draftStatusesById[lessonId];

      if (original == null || draftStatus == null) continue;
      if (original.status != draftStatus) return true;
    }

    return false;
  }

  Future<void> _handleBack() async {
    final isMutating = ref.read(libraryEditMutationProvider).isLoading;
    if (isMutating) return;

    if (!_hasUnsavedChanges) {
      if (mounted) context.pop();
      return;
    }

    bool shouldDiscard = false;

    await ConfirmAlertDialog.show(
      context,
      title: LibraryConstants.discardChangesTitle,
      description: LibraryConstants.discardChangesDescription,
      cancelLabel: LibraryConstants.discardCancelLabel,
      confirmLabel: LibraryConstants.discardConfirmLabel,
      onConfirm: () {
        shouldDiscard = true;
      },
    );

    if (!mounted) return;

    if (shouldDiscard) {
      context.pop();
    }
  }

  LessonStatus _effectiveStatusOf(int lessonId) {
    return _draftStatusesById[lessonId] ?? LessonStatus.inProgress;
  }

  bool _matchesFilter(LessonStatus status) => switch (_selectedFilter) {
        LibraryFilterOption.all => true,
        LibraryFilterOption.uploading => status == LessonStatus.uploading,
        LibraryFilterOption.inProgress => status == LessonStatus.inProgress,
        LibraryFilterOption.completed => status == LessonStatus.completed,
      };

  List<LessonItemModel> _buildVisibleItems() {
    final visible = <LessonItemModel>[];

    for (final lessonId in _initialOrderLessonIds) {
      if (_draftDeletedIds.contains(lessonId)) continue;

      final item = _originalItemsById[lessonId];
      if (item == null) continue;

      final effectiveStatus = _effectiveStatusOf(lessonId);
      if (!_matchesFilter(effectiveStatus)) continue;

      visible.add(item);
    }

    return visible;
  }

  void _toggleSelection(int lessonId) {
    if (_draftDeletedIds.contains(lessonId)) return;

    setState(() {
      if (_selectedIds.contains(lessonId)) {
        _selectedIds.remove(lessonId);
      } else {
        _selectedIds.add(lessonId);
      }
    });
  }

  LessonStatus _toModelStatus(LibraryVideoStatus v) => switch (v) {
        LibraryVideoStatus.inProgress => LessonStatus.inProgress,
        LibraryVideoStatus.completed => LessonStatus.completed,
      };

  Map<int, LessonStatus> _buildStatusChangesPayload() {
    final result = <int, LessonStatus>{};

    for (final lessonId in _initialOrderLessonIds) {
      if (_draftDeletedIds.contains(lessonId)) continue;

      final original = _originalItemsById[lessonId];
      final draftStatus = _draftStatusesById[lessonId];

      if (original == null || draftStatus == null) continue;
      if (original.status == draftStatus) continue;

      result[lessonId] = draftStatus;
    }

    return result;
  }

  /// 삭제 확인 → draft 삭제 상태에 반영 (API 즉시 호출 X)
  Future<void> _onTrashTap() async {
    final ids = _selectedIds.toList(growable: false);
    bool confirmed = false;

    await LibraryDeleteBottomSheet.show(
      context,
      onDelete: () {
        confirmed = true;
      },
    );
    if (!mounted || !confirmed) return;

    setState(() {
      _draftDeletedIds.addAll(ids);
      _selectedIds.clear();
    });
  }

  /// 상태 변경 선택 → draft 상태값에 반영 (API 즉시 호출 X)
  Future<void> _onChangeTap() async {
    final ids = _selectedIds.toList(growable: false);
    LessonStatus? chosen;

    await LibraryStatusChangeBottomSheet.show(
      context,
      onStatusChanged: (v) {
        chosen = _toModelStatus(v);
      },
    );
    if (!mounted || chosen == null) return;

    setState(() {
      for (final id in ids) {
        if (_draftDeletedIds.contains(id)) continue;
        _draftStatusesById[id] = chosen!;
      }
      _selectedIds.clear();
    });
  }

  void _onSave() {
    ref.read(libraryEditMutationProvider.notifier).saveAll(
          statusChanges: _buildStatusChangesPayload(),
          deleteIds: _draftDeletedIds.toList(growable: false),
        );
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
    ref.listen<AsyncValue<void>>(libraryEditMutationProvider, (prev, next) {
      if (prev?.isLoading != true) return;
      if (next.hasError) {
        final error = next.error;
        ErrorAlertDialog.show(
          context,
          errorMessage: error is AppException ? error.message : null,
        );
      } else if (next.hasValue) {
        context.pop(true);
      }
    });

    final isMutating = ref.watch(libraryEditMutationProvider).isLoading;

    final hasDraftChanges = _hasUnsavedChanges && !isMutating;
    final hasSelection = _selectedIds.isNotEmpty && !isMutating;

    return PopScope(
      canPop: !_hasUnsavedChanges && !isMutating,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: MingoringAppBar.actionSave(
          onBack: _handleBack,
          titleWidget: _buildTitleWidget(),
          isActionEnabled: hasDraftChanges,
          onActionPressed: _onSave,
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
                    setState(() => _selectedFilter = option);
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 학습 카드 스크롤 영역
              Expanded(child: _buildBody()),
            ],
          ),
        ),
        bottomNavigationBar: LibraryEditActionBar(
          isTrashEnabled: hasSelection,
          isChangeEnabled: hasSelection,
          onTrashTap: hasSelection ? _onTrashTap : null,
          onChangeTap: hasSelection ? _onChangeTap : null,
        ),
      ),
    );
  }

  Widget _buildBody() {
    final items = _buildVisibleItems();

    if (items.isEmpty) {
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
            children: items.map<Widget>((item) {
              final effectiveStatus = _effectiveStatusOf(item.lessonId);

              return LibraryListCard(
                width: cardWidth,
                status: effectiveStatus.toCardStatus(),
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
