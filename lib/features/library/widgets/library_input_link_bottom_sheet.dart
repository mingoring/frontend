import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/youtube_url_validator.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../../../core/widgets/dialogs/mingoring_bottom_sheet_status_overlay.dart';
import '../../../core/widgets/inputs/mingoring_text_field_verify.dart';
import '../errors/library_exception.dart';
import '../providers/library_add_video_provider.dart';

// ─────────────────────────────────────────
// Module-level constants
// ─────────────────────────────────────────
const double _borderRadius = 20.0;
const double _closeIconSize = 13.0;
const double _closeIconTopPadding = 22.0;
const double _closeIconRightPadding = 21.0;

/// close icon row 높이(35) 이후 content top=52 까지 보정
const double _contentTopSpacing = 17.0;
const double _contentHorizontalPadding = 31.0;
const double _titleIconSize = 17.0;
const double _titleIconLabelGap = 15.0;
const double _titleSubtitleGap = 3.0;
const double _frameGap = 41.0;
const double _headerFieldGap = 14.0;
const double _fieldButtonGap = 48.0;
const double _bottomPadding = 40.0;
const double _buttonHeight = 58.0;

/// 버튼 top 시작 지점 아래 영역 높이 = 버튼 높이 + 하단 패딩
/// 키보드가 이 높이만큼은 그대로 덮고, 그 위 content만 추가로 올려서 TextField가 보이게 함
const double _buttonAreaHeight = _buttonHeight + _bottomPadding;

/// keyboard inset 에서 버튼 영역 높이를 제외한 나머지만 content 하단 패딩으로 추가
const double _keyboardMinExtraPadding = 0.0;

const String _helperErrorText = 'Invalid YouTube URL';

/// 오버레이가 표시되고 자동으로 바텀시트를 닫기까지의 대기 시간
const Duration _overlayAutoDismissDelay = Duration(milliseconds: 1800);

/// 오버레이 상단 제외 높이 = closeIconTopPadding(22) + closeIconSize(13)
const double _overlayTopInset = _closeIconTopPadding + _closeIconSize;

const String _successTitle = 'Video is being added!';
const String _successDescription =
    'Your video will be ready within 24 hours.\nYou’ll get a notification when it’s done.';

const String _failureLibraryDescription =
    "Don't worry, no credits were used.\nIf the issue continues, contact us.";
const String _failureAppDescription =
    "Don't worry, no credits were used.\nIf the issue continues, please contact us.";

/// YouTube 링크 입력 바텀시트
///
/// - 사용자가 URL 입력 후 키보드의 완료 버튼을 누르면 YouTube 링크를 검증합니다.
/// - 검증에 성공하면 "Add Video" 버튼이 활성화됩니다.
/// - 버튼 탭 시 영상 추가 API를 호출합니다.
/// - 결과 처리는 provider state 전이(ref.listen)로만 처리합니다.
/// - 성공 시 오버레이를 띄운 뒤 자동 닫힘하고 `Navigator.pop(context, true)`로 반환합니다.
///
/// 사용 예시:
/// ```dart
/// final added = await LibraryInputLinkBottomSheet.show<bool>(context);
/// if (added == true) { /* 목록 새로고침 */ }
/// ```
class LibraryInputLinkBottomSheet extends ConsumerStatefulWidget {
  const LibraryInputLinkBottomSheet({super.key});

  static Future<T?> show<T>(
    BuildContext context, {
    Color barrierColor = AppColors.black50,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      builder: (_) => const LibraryInputLinkBottomSheet(),
    );
  }

  @override
  ConsumerState<LibraryInputLinkBottomSheet> createState() =>
      _LibraryInputLinkBottomSheetState();
}

class _LibraryInputLinkBottomSheetState
    extends ConsumerState<LibraryInputLinkBottomSheet> {
  final _urlController = TextEditingController();
  final _focusNode = FocusNode();

  MingoringValidationStatus _validationStatus =
      MingoringValidationStatus.none;
  String? _helperText;

  MingoringBottomSheetOverlayStatus? _overlayStatus;
  String? _overlayTitle = _successTitle;
  String? _overlayDescription = _successDescription;

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.isEmpty && _validationStatus != MingoringValidationStatus.none) {
      setState(() {
        _validationStatus = MingoringValidationStatus.none;
        _helperText = null;
      });
    }
  }

  void _onSubmitted(String value) {
    final isValid = YoutubeUrlValidator.isValid(value);

    setState(() {
      _validationStatus = value.isEmpty
          ? MingoringValidationStatus.none
          : isValid
              ? MingoringValidationStatus.success
              : MingoringValidationStatus.error;
      _helperText = (!isValid && value.isNotEmpty) ? _helperErrorText : null;
    });

    FocusScope.of(context).unfocus();
  }

  bool get _isSubmitting => ref.read(libraryAddVideoProvider).isLoading;

  bool get _isAddEnabled =>
      _validationStatus == MingoringValidationStatus.success &&
      !_isSubmitting &&
      _overlayStatus == null;

  Future<void> _handleAddVideoStateChanged(
    AsyncValue<void>? prev,
    AsyncValue<void> next,
  ) async {
    if (prev?.isLoading != true || !mounted) return;

    next.whenOrNull(
      data: (_) async {
        setState(() {
          _overlayTitle = _successTitle;
          _overlayDescription = _successDescription;
          _overlayStatus = MingoringBottomSheetOverlayStatus.success;
        });

        await Future.delayed(_overlayAutoDismissDelay);
        if (!mounted) return;
        Navigator.of(context).pop(true);
      },
      error: (error, _) async {
        if (error is LibraryException) {
          setState(() {
            _overlayTitle = error.message;
            _overlayDescription = _failureLibraryDescription;
            _overlayStatus = MingoringBottomSheetOverlayStatus.failure;
          });
        } else {
          setState(() {
            _overlayTitle = null;
            _overlayDescription = _failureAppDescription;
            _overlayStatus = MingoringBottomSheetOverlayStatus.failure;
          });
        }

        await Future.delayed(_overlayAutoDismissDelay);
        if (!mounted) return;
        setState(() {
          _overlayStatus = null;
        });
      },
    );
  }

  void _onAddPressed() {
    final normalizedUrl =
        YoutubeUrlValidator.normalizeUrl(_urlController.text.trim());

    ref.read(libraryAddVideoProvider.notifier).addVideo(normalizedUrl);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(libraryAddVideoProvider, (prev, next) {
      _handleAddVideoStateChanged(prev, next);
    });

    final addVideoState = ref.watch(libraryAddVideoProvider);
    final isSubmitting = addVideoState.isLoading;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final extraBottomPadding =
        (keyboardHeight - _buttonAreaHeight)
            .clamp(_keyboardMinExtraPadding, double.infinity)
            .toDouble();

    return MingoringBottomSheetStatusOverlay(
      overlayStatus: _overlayStatus,
      title: _overlayTitle,
      description: _overlayDescription,
      topInset: _overlayTopInset,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_borderRadius),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: extraBottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: _overlayStatus == null
                          ? () => Navigator.of(context).pop()
                          : null,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: _closeIconTopPadding,
                          right: _closeIconRightPadding,
                        ),
                        child: SvgPicture.asset(
                          AppIconAssets.close,
                          width: _closeIconSize,
                          height: _closeIconSize,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _contentTopSpacing),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _contentHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppIconAssets.video,
                                    width: _titleIconSize,
                                    height: _titleIconSize,
                                  ),
                                  const SizedBox(width: _titleIconLabelGap),
                                  Expanded(
                                    child: Text(
                                      'Add New Video',
                                      style: AppTextStyles.head6B18.copyWith(
                                        color: AppColors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: _titleSubtitleGap),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: _titleIconSize + _titleIconLabelGap,
                                ),
                                child: Text(
                                  'Paste a YouTube link to add to your library!',
                                  style: AppTextStyles.detail2Sb13.copyWith(
                                    color: AppColors.gray500,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: _frameGap),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  _BulletText('Only supports Korean video'),
                                  _BulletText("Can't upload Youtube Shorts"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: _headerFieldGap),
                          MingoringTextFieldVerify(
                            controller: _urlController,
                            focusNode: _focusNode,
                            hintText: 'Paste YouTube video URL here',
                            leadingIconAsset: AppIconAssets.link,
                            showMax: false,
                            validationStatus: _validationStatus,
                            helperText: _helperText,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onChanged: _onChanged,
                            onSubmitted: _onSubmitted,
                          ),
                        ],
                      ),
                      const SizedBox(height: _fieldButtonGap),
                      SizedBox(
                        width: double.infinity,
                        child: MingoringTextButton(
                          onPressed: _isAddEnabled ? _onAddPressed : null,
                          size: MingoringTextButtonSize.big,
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Add Video'),
                        ),
                      ),
                      const SizedBox(height: _bottomPadding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
