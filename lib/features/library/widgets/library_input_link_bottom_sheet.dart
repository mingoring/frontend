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

/// close icon row 높이(35) 이후, 본문 content 시작점(top=52)까지의 보정 간격
const double _contentTopSpacing = 17.0;

/// 본문 content 좌우 패딩
const double _contentHorizontalPadding = 31.0;

const double _headerIconSize = 17.0;
const double _headerIconTextGap = 15.0;
const double _titleSubtitleGap = 3.0;
const double _headerDescriptionGap = 16.0;
const double _descriptionLineGap = 2.0;

const double _headerFieldGap = 14.0;
const double _fieldButtonGap = 48.0;
const double _bottomPadding = 40.0;
const double _buttonHeight = 58.0;

/// 버튼 영역 전체 높이 = 버튼 높이 + 버튼 하단 패딩
///
/// 키보드가 올라오면 이 영역은 그대로 키보드에 걸치도록 두고,
/// 그 위의 content 영역만 추가로 올려 TextField가 가려지지 않게 한다.
const double _buttonAreaHeight = _buttonHeight + _bottomPadding;

/// keyboard inset 에서 버튼 영역 높이를 제외한 나머지만
/// content 하단 padding 으로 추가한다.
const double _keyboardMinExtraPadding = 0.0;

const String _helperErrorText = 'Invalid YouTube URL';

/// 성공/실패 오버레이 노출 후 자동 전환까지의 대기 시간
///
/// - 성공: 이 시간이 지난 뒤 바텀시트를 닫고 true 반환
/// - 실패: 이 시간이 지난 뒤 오버레이만 제거하고 입력 화면으로 복귀
const Duration _overlayAutoDismissDelay = Duration(milliseconds: 2500);

/// 오버레이가 덮지 않을 상단 높이
///
/// close button row 높이와 동일하게 맞춰,
/// X 버튼은 오버레이 위에서도 계속 보이고 탭 가능하도록 한다.
/// = closeIconTopPadding(22) + closeIconSize(13)
const double _overlayTopInset = _closeIconTopPadding + _closeIconSize;

// Header texts
const String _headerTitle = 'Add New Video';
const String _headerSubtitle = 'Paste a YouTube link to add to your library!';
const String _descriptionLine1 = 'Only supports Korean video';
const String _descriptionLine2 = "Can't upload YouTube Shorts";

// Overlay texts
const String _successTitle = 'Video is being added!';
const String _successDescription =
    'Your video will be ready within 24 hours.\nYou’ll get a notification when it’s done.';

const String _failureLibraryDescription =
    "Don't worry, no credits were used.";
const String _failureAppDescription =
    "Don't worry, no credits were used.\nIf the issue continues, please contact us.";

// Header text styles
final TextStyle _headerTitleTextStyle = AppTextStyles.head6B18.copyWith(
  color: AppColors.black,
  height: 1.2,
);

final TextStyle _headerSubtitleTextStyle = AppTextStyles.detail2Sb13.copyWith(
  color: AppColors.gray500,
  height: 1.1,
);

final TextStyle _headerDescriptionTextStyle =
    AppTextStyles.detail6Md12.copyWith(
      color: AppColors.gray500,
      height: 1.2,
    );

/// YouTube 링크 입력 바텀시트
///
/// 동작:
/// - 사용자가 URL 입력 후 키보드의 완료 버튼을 누르면 1차 YouTube 링크 검증을 수행한다.
/// - 검증에 성공하면 "Add" 버튼이 활성화된다.
/// - "Add" 버튼 탭 시 영상 추가 API 를 호출한다.
/// - 성공/실패 후속 처리는 반환값이 아니라 provider state 전이(ref.listen)로만 처리한다.
/// - 성공 시 성공 오버레이를 잠시 노출한 뒤 바텀시트를 닫고 `true`를 반환한다.
/// - 실패 시 실패 오버레이를 잠시 노출한 뒤 오버레이만 제거하고 입력 화면으로 복귀한다.
///
/// 레이아웃:
/// - 바텀시트 본문 컨테이너는 `width: double.infinity`로 전체 가로 폭을 사용한다.
/// - 오버레이는 부모의 좌우 여백과 무관하게 화면 전체 폭을 덮는다.
///   (`MingoringBottomSheetStatusOverlay` 내부에서 MediaQuery 기반으로 보정)
/// - 단, 오버레이 상단은 [_overlayTopInset] 만큼 비워 X 버튼 영역을 유지한다.
///
/// 사용 예시:
/// ```dart
/// final added = await LibraryInputLinkBottomSheet.show<bool>(context);
/// if (added == true) {
///   // 목록 새로고침
/// }
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
        /// 바텀시트 본문과 오버레이가 동일한 전체 가로 폭을 사용하도록 명시
        width: double.infinity,
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
                      const _HeaderSection(),
                      const SizedBox(height: _headerFieldGap),
                      MingoringTextFieldVerify(
                        controller: _urlController,
                        focusNode: _focusNode,
                        hintText: 'https://youtu.be/..',
                        leadingIconAsset: AppIconAssets.link,
                        showMax: false,
                        validationStatus: _validationStatus,
                        helperText: _helperText,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onChanged: _onChanged,
                        onSubmitted: _onSubmitted,
                      ),
                      const SizedBox(height: _headerDescriptionGap),
                      const _DescriptionSection(),
                      const SizedBox(height: _fieldButtonGap),
                      SizedBox(
                        width: double.infinity,
                        child: MingoringTextButton(
                          onPressed: _isAddEnabled ? _onAddPressed : null,
                          size: MingoringTextButtonSize.small,
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Add'),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  String get title => _headerTitle;
  String get subtitle => _headerSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIconAssets.video,
          width: _headerIconSize,
          height: _headerIconSize,
        ),
        const SizedBox(width: _headerIconTextGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: _headerTitleTextStyle),
              const SizedBox(height: _titleSubtitleGap),
              Text(subtitle, style: _headerSubtitleTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  String get descriptionLine1 => _descriptionLine1;
  String get descriptionLine2 => _descriptionLine2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $descriptionLine1',
          style: _headerDescriptionTextStyle,
        ),
        const SizedBox(height: _descriptionLineGap),
        Text(
          '• $descriptionLine2',
          style: _headerDescriptionTextStyle,
        ),
      ],
    );
  }
}
