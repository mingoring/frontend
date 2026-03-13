import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs/mingoring_bottom_sheet.dart';

/// 로그아웃 확인 바텀시트 (auth feature 전용)
///
/// 사용 예시:
/// ```dart
/// AuthLogoutBottomSheet.show(
///   context,
///   onLogout: () {
///     // logout logic
///   },
/// );
/// ```
class AuthLogoutBottomSheet {
  const AuthLogoutBottomSheet._();

  static const String _title = 'Log Out';
  static const String _subtitle = 'Are you sure you want to log out?';
  static const String _primaryButtonText = 'Log Out';
  static const String _secondaryButtonText = 'Cancel';

  /// 로그아웃 확인 바텀시트를 표시합니다.
  ///
  /// [onLogout]: 로그아웃 버튼(핑크) 탭 시 실행됩니다.
  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback onLogout,
  }) {
    return MingoringBottomSheet.show<T>(
      context,
      title: _title,
      subtitle: _subtitle,
      primaryButtonText: _primaryButtonText,
      secondaryButtonText: _secondaryButtonText,
      onPrimaryPressed: onLogout,
      // primaryButtonOnLeft: false → Cancel(좌/회색) | Log Out(우/핑크)
    );
  }
}
