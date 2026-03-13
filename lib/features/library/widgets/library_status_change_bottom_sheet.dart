import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs/mingoring_bottom_sheet.dart';
import '../models/library_filter_option.dart';

/// 동영상 학습 상태 선택 값
enum LibraryVideoStatus { inProgress, completed }

/// 동영상 상태 변경 확인 바텀시트 (library feature 전용)
///
/// - 현재 필터 기준으로 변경 방향을 서브타이틀에 표시합니다.
///   - In Progress 필터 → "In Progress → Completed"
///   - Completed 필터 → "Completed → In Progress"
///
/// 사용 예시:
/// ```dart
/// LibraryStatusChangeBottomSheet.show(
///   context,
///   currentFilter: _selectedFilter,
///   onStatusChanged: (status) {
///     // status change logic
///   },
/// );
/// ```
class LibraryStatusChangeBottomSheet {
  const LibraryStatusChangeBottomSheet._();

  static const String _title = 'Change Status';
  static const String _primaryButtonText = 'Change';
  static const String _secondaryButtonText = 'Cancel';

  static String _subtitle(LibraryFilterOption currentFilter) =>
      currentFilter == LibraryFilterOption.inProgress
          ? 'In Progress → Completed'
          : 'Completed → In Progress';

  static LibraryVideoStatus _targetStatus(LibraryFilterOption currentFilter) =>
      currentFilter == LibraryFilterOption.inProgress
          ? LibraryVideoStatus.completed
          : LibraryVideoStatus.inProgress;

  /// 상태 변경 확인 바텀시트를 표시합니다.
  ///
  /// [onStatusChanged]: Change 버튼 탭 시 변경할 목표 상태와 함께 실행됩니다.
  static Future<T?> show<T>(
    BuildContext context, {
    required LibraryFilterOption currentFilter,
    required ValueChanged<LibraryVideoStatus> onStatusChanged,
  }) {
    final targetStatus = _targetStatus(currentFilter);

    return MingoringBottomSheet.show<T>(
      context,
      title: _title,
      subtitle: _subtitle(currentFilter),
      primaryButtonText: _primaryButtonText,
      secondaryButtonText: _secondaryButtonText,
      onPrimaryPressed: () => onStatusChanged(targetStatus),
    );
  }
}
