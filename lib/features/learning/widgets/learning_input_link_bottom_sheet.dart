import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/youtube_url_validator.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../../../core/widgets/inputs/mingoring_text_field_verify.dart';

// ─────────────────────────────────────────
// Module-level constants
// ─────────────────────────────────────────
const double _kBorderRadius = 20.0;
const double _kCloseIconSize = 13.0;
const double _kCloseIconTopPadding = 22.0;
const double _kCloseIconRightPadding = 21.0;

/// close icon row 높이(35) 이후 content top=52 까지 보정
const double _kContentTopSpacing = 17.0;
const double _kContentHorizontalPadding = 31.0;
const double _kTitleIconSize = 17.0;
const double _kTitleIconLabelGap = 15.0;
const double _kTitleSubtitleGap = 3.0;
const double _kFrameGap = 41.0;
const double _kHeaderFieldGap = 14.0;
const double _kFieldButtonGap = 48.0;
const double _kBottomPadding = 40.0;
const String _kHelperErrorText = 'Invalid YouTube URL';

/// YouTube 링크 입력 바텀시트 (learning feature 전용)
///
/// - URL 입력 시 실시간 YouTube 링크 검증 수행
/// - 검증 성공 시 "Create Learning" 버튼이 활성화됩니다.
///
/// 사용 예시:
/// ```dart
/// LearningInputLinkBottomSheet.show(
///   context,
///   onCreateLearning: (url) {
///     // create learning with url
///   },
/// );
/// ```
class LearningInputLinkBottomSheet extends StatefulWidget {
  const LearningInputLinkBottomSheet({
    super.key,
    this.onCreateLearning,
  });

  /// 유효한 YouTube URL 이 확인되고 버튼 탭 시 호출되는 콜백
  final ValueChanged<String>? onCreateLearning;

  static Future<T?> show<T>(
    BuildContext context, {
    ValueChanged<String>? onCreateLearning,
    Color barrierColor = AppColors.black50,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_kBorderRadius),
        ),
      ),
      builder: (_) => LearningInputLinkBottomSheet(
        onCreateLearning: onCreateLearning,
      ),
    );
  }

  @override
  State<LearningInputLinkBottomSheet> createState() =>
      _LearningInputLinkBottomSheetState();
}

class _LearningInputLinkBottomSheetState
    extends State<LearningInputLinkBottomSheet> {
  final _urlController = TextEditingController();
  MingoringValidationStatus _validationStatus =
      MingoringValidationStatus.none;
  String? _helperText;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _validationStatus = MingoringValidationStatus.none;
        _helperText = null;
      });
      return;
    }

    final isValid = YoutubeUrlValidator.isValid(value);
    setState(() {
      _validationStatus = isValid
          ? MingoringValidationStatus.success
          : MingoringValidationStatus.error;
      _helperText = isValid ? null : _kHelperErrorText;
    });
  }

  bool get _isCreateEnabled =>
      _validationStatus == MingoringValidationStatus.success;

  void _onCreatePressed() {
    Navigator.of(context).pop();
    widget.onCreateLearning?.call(_urlController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_kBorderRadius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Close button row ──────────────────
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: _kCloseIconTopPadding,
                        right: _kCloseIconRightPadding,
                      ),
                      child: SvgPicture.asset(
                        AppIconAssets.close,
                        width: _kCloseIconSize,
                        height: _kCloseIconSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _kContentTopSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _kContentHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header + TextField ────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title frame
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title row: ic_video + text
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppIconAssets.video,
                                  width: _kTitleIconSize,
                                  height: _kTitleIconSize,
                                ),
                                const SizedBox(width: _kTitleIconLabelGap),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Create New Learning',
                                        style: AppTextStyles.head6B18.copyWith(
                                          color: AppColors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: _kTitleSubtitleGap),
                                      Text(
                                        'Paste a YouTube link, and start learning!',
                                        style:
                                            AppTextStyles.detail2Sb13.copyWith(
                                          color: AppColors.gray500,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: _kFrameGap),
                            // Bullet list
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _BulletText('Only supports Korean video'),
                                _BulletText("Can't upload Youtube Shorts"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: _kHeaderFieldGap),
                        // TextField
                        MingoringTextFieldVerify(
                          controller: _urlController,
                          hintText: 'Paste YouTube video URL here',
                          leadingIconAsset: AppIconAssets.link,
                          showMax: false,
                          validationStatus: _validationStatus,
                          helperText: _helperText,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onChanged: _onUrlChanged,
                        ),
                      ],
                    ),
                    const SizedBox(height: _kFieldButtonGap),
                    // ── Create Learning button ────────
                    SizedBox(
                      width: double.infinity,
                      child: MingoringTextButton(
                        onPressed:
                            _isCreateEnabled ? _onCreatePressed : null,
                        size: MingoringTextButtonSize.big,
                        child: const Text('Create Learning'),
                      ),
                    ),
                    const SizedBox(height: _kBottomPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────

class _BulletText extends StatelessWidget {
  const _BulletText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: AppTextStyles.detail6Md12.copyWith(
            color: AppColors.gray500,
            height: 1.2,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.detail6Md12.copyWith(
              color: AppColors.gray500,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
