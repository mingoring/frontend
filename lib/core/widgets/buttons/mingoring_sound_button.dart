import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';

/// 사운드(오디오) 재생 버튼.
///
/// - **기본(Idle)**: `btn_sound_gray800`
/// - **꾹 누르는 중(Pressed)** / **재생 중(Playing)**: `btn_sound_pink600`
///
/// 사용 예시:
/// ```dart
/// MingoringSoundButton(
///   isPlaying: isPlaying,
///   onPressed: onSoundPressed,
/// )
/// ```
class MingoringSoundButton extends StatefulWidget {
  const MingoringSoundButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
  });

  final bool isPlaying;
  final VoidCallback? onPressed;

  static const double _buttonSize = 34.0;

  @override
  State<MingoringSoundButton> createState() => _MingoringSoundButtonState();
}

class _MingoringSoundButtonState extends State<MingoringSoundButton> {
  bool _isPressed = false;

  String get _currentAsset {
    if (_isPressed) return AppIconAssets.btnSoundPink600;
    if (widget.isPlaying) return AppIconAssets.btnSoundPink600;
    return AppIconAssets.btnSoundGray800;
  }

  void _setPressed(bool pressed) {
    if (_isPressed == pressed) return;
    setState(() => _isPressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: SvgPicture.asset(
        _currentAsset,
        width: MingoringSoundButton._buttonSize,
        height: MingoringSoundButton._buttonSize,
      ),
    );
  }
}
