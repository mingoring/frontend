import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'playing_speed_popup.dart';

/// 영상 재생 컨트롤 바 (하단 고정)
///
/// 속도 선택 · 이전 탐색 · 재생/일시정지 · 다음 탐색 · 자동재생 토글
///
/// 사용 예:
/// ```dart
/// PlayingBar(
///   isPlaying: _isPlaying,
///   selectedSpeed: _selectedSpeed,
///   isAutoPlay: _isAutoPlay,
///   onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
///   onBack: _seekBack,
///   onForward: _seekForward,
///   onSpeedTap: () => setState(() => _showSpeedPopup = !_showSpeedPopup),
///   onAutoPlayTap: () => setState(() => _isAutoPlay = !_isAutoPlay),
/// )
/// ```
class PlayingBar extends StatelessWidget {
  const PlayingBar({
    super.key,
    required this.isPlaying,
    required this.selectedSpeed,
    required this.isAutoPlay,
    required this.onPlayPause,
    required this.onBack,
    required this.onForward,
    required this.onSpeedTap,
    required this.onAutoPlayTap,
  });

  static const double height = 86;
  static const double _playButtonSize = 50;
  static const double _safeAreaOffset = 35;
  static const double _controlTopPadding = 32;
  static const double _playTopPadding = 10;

  final bool isPlaying;
  final PlaybackSpeed selectedSpeed;
  final bool isAutoPlay;
  final VoidCallback onPlayPause;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onSpeedTap;
  final VoidCallback onAutoPlayTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200,
            offset: Offset(0, -1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          _SpeedCell(
            isPlaying: isPlaying,
            label: selectedSpeed.label,
            onTap: onSpeedTap,
          ),
          _BackCell(isPlaying: isPlaying, onTap: onBack),
          _PlayCell(isPlaying: isPlaying, onTap: onPlayPause),
          _ForwardCell(isPlaying: isPlaying, onTap: onForward),
          _AutoCell(isAutoPlay: isAutoPlay, onTap: onAutoPlayTap),
        ],
      ),
    );
  }
}

// ─── 속도 셀 ──────────────────────────────────────────────────────────────────

class _SpeedCell extends StatelessWidget {
  const _SpeedCell({
    required this.isPlaying,
    required this.label,
    required this.onTap,
  });

  final bool isPlaying;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: PlayingBar._controlTopPadding,
            bottom: PlayingBar._safeAreaOffset,
          ),
          child: Text(
            label,
            style: AppTextStyles.detail7Md10.copyWith(
              color: isPlaying ? AppColors.gray800 : AppColors.gray400,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 뒤로 탐색 셀 ────────────────────────────────────────────────────────────

class _BackCell extends StatelessWidget {
  const _BackCell({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          color: AppColors.white,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: PlayingBar._controlTopPadding,
            bottom: PlayingBar._safeAreaOffset,
          ),
          child: SvgPicture.asset(
            AppIconAssets.videoPlayingLeft2,
            width: 18,
            height: 12,
            colorFilter: ColorFilter.mode(
              isPlaying ? AppColors.gray800 : AppColors.gray400,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 재생/일시정지 셀 ──────────────────────────────────────────────────────────

class _PlayCell extends StatelessWidget {
  const _PlayCell({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          color: AppColors.white,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: PlayingBar._playTopPadding,
            bottom: PlayingBar._safeAreaOffset,
          ),
          child: SvgPicture.asset(
            isPlaying ? AppIconAssets.btnVideoStop : AppIconAssets.btnVideoPlay,
            width: PlayingBar._playButtonSize,
            height: PlayingBar._playButtonSize,
          ),
        ),
      ),
    );
  }
}

// ─── 앞으로 탐색 셀 ──────────────────────────────────────────────────────────

class _ForwardCell extends StatelessWidget {
  const _ForwardCell({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          color: AppColors.white,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: PlayingBar._controlTopPadding,
            bottom: PlayingBar._safeAreaOffset,
          ),
          child: SvgPicture.asset(
            AppIconAssets.videoPlayingRight2,
            width: 18,
            height: 12,
            colorFilter: ColorFilter.mode(
              isPlaying ? AppColors.gray800 : AppColors.gray400,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 자동재생 셀 ──────────────────────────────────────────────────────────────

class _AutoCell extends StatelessWidget {
  const _AutoCell({required this.isAutoPlay, required this.onTap});

  final bool isAutoPlay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: PlayingBar._controlTopPadding,
            bottom: PlayingBar._safeAreaOffset,
          ),
          child: SvgPicture.asset(
            isAutoPlay
                ? AppIconAssets.videoPlayingAutoOn
                : AppIconAssets.videoPlayingAutoOff,
            width: 20,
            height: 18,
          ),
        ),
      ),
    );
  }
}
