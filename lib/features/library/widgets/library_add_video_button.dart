import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';

/// 라이브러리 화면 우측 하단 영상 추가 Floating 버튼
///
/// Usage:
/// ```dart
/// LibraryAddVideoButton(onTap: () { /* 영상 추가 로직 */ }),
/// ```
class LibraryAddVideoButton extends StatelessWidget {
  const LibraryAddVideoButton({super.key, required this.onTap});

  final VoidCallback onTap;

  static const double _size = 56.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppIconAssets.btnPlus2,
          width: _size,
          height: _size,
        ),
      ),
    );
  }
}
