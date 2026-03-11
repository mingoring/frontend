import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/mingoring_watch_button.dart';

enum BookmarkCardState { idle, playing }

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.originalText,
    required this.translatedText,
    this.type = BookmarkCardState.idle,
    this.onSoundPressed,
    this.onWatchPressed,
  });

  final String originalText;
  final String translatedText;
  final BookmarkCardState type;
  final VoidCallback? onSoundPressed;
  final VoidCallback? onWatchPressed;

  static const double _cardHeight = 70.0;
  static const double _cardBorderRadius = 20.0;
  static const double _horizontalPadding = 20.0;
  static const double _verticalPadding = 10.0;
  static const double _textGap = 2.0;
  static const double _buttonGap = 9.0;
  static const double _soundButtonSize = 34.0;
  static const double _soundButtonBorderWidth = 0.68;
  static const double _soundIconSize = 10.88;
  static const double _soundButtonBorderRadius = 30.0;

  bool get _isPlaying => type == BookmarkCardState.playing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      decoration: BoxDecoration(
        color: _isPlaying ? AppColors.pink200 : AppColors.white,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: Border.all(
          color: _isPlaying ? AppColors.pink600 : AppColors.gray400,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _BookmarkCardText(
              originalText: originalText,
              translatedText: translatedText,
              isPlaying: _isPlaying,
            ),
          ),
          _BookmarkCardButtons(
            isPlaying: _isPlaying,
            onSoundPressed: onSoundPressed,
            onWatchPressed: onWatchPressed,
            soundButtonSize: _soundButtonSize,
            soundButtonBorderWidth: _soundButtonBorderWidth,
            soundIconSize: _soundIconSize,
            soundButtonBorderRadius: _soundButtonBorderRadius,
            buttonGap: _buttonGap,
          ),
        ],
      ),
    );
  }
}

class _BookmarkCardText extends StatelessWidget {
  const _BookmarkCardText({
    required this.originalText,
    required this.translatedText,
    required this.isPlaying,
  });

  final String originalText;
  final String translatedText;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          originalText,
          style: AppTextStyles.body4B15.copyWith(
            color: isPlaying ? AppColors.pink600 : AppColors.gray900,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: BookmarkCard._textGap),
        Text(
          translatedText,
          style: AppTextStyles.body9Md14.copyWith(
            color: AppColors.gray600,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _BookmarkCardButtons extends StatelessWidget {
  const _BookmarkCardButtons({
    required this.isPlaying,
    required this.onSoundPressed,
    required this.onWatchPressed,
    required this.soundButtonSize,
    required this.soundButtonBorderWidth,
    required this.soundIconSize,
    required this.soundButtonBorderRadius,
    required this.buttonGap,
  });

  final bool isPlaying;
  final VoidCallback? onSoundPressed;
  final VoidCallback? onWatchPressed;
  final double soundButtonSize;
  final double soundButtonBorderWidth;
  final double soundIconSize;
  final double soundButtonBorderRadius;
  final double buttonGap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SoundButton(
          isPlaying: isPlaying,
          onPressed: onSoundPressed,
          size: soundButtonSize,
          borderWidth: soundButtonBorderWidth,
          iconSize: soundIconSize,
          borderRadius: soundButtonBorderRadius,
        ),
        SizedBox(width: buttonGap),
        MingoringWatchButton(
          onPressed: onWatchPressed,
          size: MingoringWatchButtonSize.small,
        ),
      ],
    );
  }
}

class _SoundButton extends StatelessWidget {
  const _SoundButton({
    required this.isPlaying,
    required this.onPressed,
    required this.size,
    required this.borderWidth,
    required this.iconSize,
    required this.borderRadius,
  });

  final bool isPlaying;
  final VoidCallback? onPressed;
  final double size;
  final double borderWidth;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPlaying ? AppColors.pink600 : AppColors.gray400,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            isPlaying ? AppIconAssets.btnSoundOn : AppIconAssets.btnSoundOff,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
