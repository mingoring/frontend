import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs/mingoring_bottom_sheet.dart';

/// 회원 탈퇴 확인 바텀시트 (auth feature 전용)
///
/// - 왼쪽 버튼(핑크): Stay — 시트를 닫고 현재 화면에 머무릅니다.
/// - 오른쪽 버튼(회색): Delete Account — 탈퇴 로직을 실행합니다.
///
/// 사용 예시:
/// ```dart
/// AuthWithdrawBottomSheet.show(
///   context,
///   onWithdraw: () {
///     // withdraw logic
///   },
/// );
/// ```
class AuthWithdrawBottomSheet {
  const AuthWithdrawBottomSheet._();

  static const String _title = 'Delete Account';
  static const String _subtitle =
      "Are you sure you want to leave Mingo? If you delete your account, learning history can't be recovered.";
  static const String _primaryButtonText = 'Stay';
  static const String _secondaryButtonText = 'Delete Account';

  /// 회원 탈퇴 확인 바텀시트를 표시합니다.
  ///
  /// [onWithdraw]: Delete Account 버튼(회색) 탭 시 실행됩니다.
  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback onWithdraw,
  }) {
    return MingoringBottomSheet.show<T>(
      context,
      title: _title,
      subtitle: _subtitle,
      primaryButtonText: _primaryButtonText,
      secondaryButtonText: _secondaryButtonText,
      // Stay 버튼은 시트를 닫기만 하면 되므로 빈 콜백 전달
      onPrimaryPressed: () {},
      onSecondaryPressed: onWithdraw,
      primaryButtonOnLeft: true,
      // primaryButtonOnLeft: true → Stay(좌/핑크) | Delete Account(우/회색)
    );
  }
}
