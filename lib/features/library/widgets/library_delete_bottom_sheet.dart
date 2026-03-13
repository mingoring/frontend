import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs/mingoring_bottom_sheet.dart';

/// 동영상 삭제 확인 바텀시트 (library feature 전용)
///
/// 사용 예시:
/// ```dart
/// LibraryDeleteBottomSheet.show(
///   context,
///   onDelete: () {
///     // delete logic
///   },
/// );
/// ```
class LibraryDeleteBottomSheet {
  const LibraryDeleteBottomSheet._();

  static const String _title = 'Delete Video';
  static const String _subtitle =
      'Are you sure you want to delete this video?\nThis action cannot be undone.';
  static const String _primaryButtonText = 'Delete';
  static const String _secondaryButtonText = 'Cancel';

  /// 삭제 확인 바텀시트를 표시합니다.
  ///
  /// [onDelete]: Delete 버튼 탭 시 실행됩니다.
  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback onDelete,
  }) {
    return MingoringBottomSheet.show<T>(
      context,
      title: _title,
      subtitle: _subtitle,
      primaryButtonText: _primaryButtonText,
      secondaryButtonText: _secondaryButtonText,
      onPrimaryPressed: onDelete,
    );
  }
}
