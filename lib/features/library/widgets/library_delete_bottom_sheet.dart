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
      'Are you sure you want to delete the selected video?';
  static const String _primaryButtonText = 'Delete';
  static const String _secondaryButtonText = 'Cancel';

  /// 삭제 확인 바텀시트를 표시합니다.
  ///
  /// [onDelete]: 삭제 버튼(핑크) 탭 시 실행됩니다.
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
      // primaryButtonOnLeft: false → Cancel(좌/회색) | Delete(우/핑크)
    );
  }
}
