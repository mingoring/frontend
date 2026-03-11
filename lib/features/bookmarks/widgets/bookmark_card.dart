import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/mingoring_sound_button.dart';
import '../../../core/widgets/buttons/mingoring_watch_button.dart';

enum BookmarkCardState { idle, playing }

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.originalText,
    required this.translatedText,
    this.type = BookmarkCardState.idle,
    this.onTap,
    this.onSoundPressed,
    this.onWatchPressed,
  });

  final String originalText;
  final String translatedText;
  final BookmarkCardState type;
  /// 버튼 영역을 제외한 카드 텍스트 영역 탭 콜백
  final VoidCallback? onTap;
  final VoidCallback? onSoundPressed;
  final VoidCallback? onWatchPressed;

  static const double _cardHeight = 70.0;
  static const double _cardBorderRadius = 20.0;
  static const double _horizontalPadding = 20.0;
  static const double _verticalPadding = 10.0;
  static const double _textGap = 2.0;
  static const double _buttonGap = 9.0;

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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: _BookmarkCardText(
                originalText: originalText,
                translatedText: translatedText,
                isPlaying: _isPlaying,
              ),
            ),
          ),
          _BookmarkCardButtons(
            isPlaying: _isPlaying,
            onSoundPressed: onSoundPressed,
            onWatchPressed: onWatchPressed,
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
    required this.buttonGap,
  });

  final bool isPlaying;
  final VoidCallback? onSoundPressed;
  final VoidCallback? onWatchPressed;
  final double buttonGap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MingoringSoundButton(
          isPlaying: isPlaying,
          onPressed: onSoundPressed,
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
