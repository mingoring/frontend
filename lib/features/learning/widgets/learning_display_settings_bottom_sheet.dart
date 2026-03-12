import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/inputs/mingoring_switch_toggle.dart';

// ─────────────────────────────────────────
// Module-level constants
// ─────────────────────────────────────────
const double _kBorderRadius = 20.0;
const double _kCloseIconSize = 13.0;
const double _kCloseIconTopPadding = 22.0;
const double _kCloseIconRightPadding = 21.0;
const double _kContentTopSpacing = 11.0;
const double _kContentHorizontalPadding = 31.0;
const double _kTitleRowGap = 34.0;
const double _kRowGap = 8.0;
const double _kRowDividerGap = 23.0;
const double _kDividerCheckGap = 17.0;
const double _kBottomPadding = 40.0;
const double _kToggleIconSize = 14.0;
const double _kCheckIconSize = 16.0;
const double _kIconLabelGap = 11.0;

/// 학습 화면 표시 설정 바텀시트 (learning feature 전용)
///
/// 각 항목의 초기값을 주입하고, 변경 시 해당 콜백이 즉시 호출됩니다.
/// - 토글 ON/OFF 시 좌측 아이콘 색상이 pink600 ↔ gray400 으로 변경됩니다.
/// - 북마크 체크 행은 탭 시 ic_check1 아이콘이 on/off 전환됩니다.
///
/// 사용 예시:
/// ```dart
/// LearningDisplaySettingsBottomSheet.show(
///   context,
///   showKorean: true,
///   showEnglish: true,
///   showDescription: false,
///   showBookmarksOnly: false,
///   onShowKoreanChanged: (v) { /* update provider */ },
///   onShowEnglishChanged: (v) { /* update provider */ },
///   onShowDescriptionChanged: (v) { /* update provider */ },
///   onShowBookmarksOnlyChanged: (v) { /* update provider */ },
/// );
/// ```
class LearningDisplaySettingsBottomSheet extends StatefulWidget {
  const LearningDisplaySettingsBottomSheet({
    super.key,
    this.showKorean = true,
    this.showEnglish = true,
    this.showDescription = false,
    this.showBookmarksOnly = false,
    this.onShowKoreanChanged,
    this.onShowEnglishChanged,
    this.onShowDescriptionChanged,
    this.onShowBookmarksOnlyChanged,
  });

  /// Show Korean 토글 초기값 (기본 ON)
  final bool showKorean;

  /// Show English 토글 초기값 (기본 ON)
  final bool showEnglish;

  /// Show Description/patterns 토글 초기값 (기본 OFF)
  final bool showDescription;

  /// Show Bookmarks Only 체크 초기값 (기본 OFF)
  final bool showBookmarksOnly;

  final ValueChanged<bool>? onShowKoreanChanged;
  final ValueChanged<bool>? onShowEnglishChanged;
  final ValueChanged<bool>? onShowDescriptionChanged;
  final ValueChanged<bool>? onShowBookmarksOnlyChanged;

  /// 표시 설정 바텀시트를 표시하는 편의 메서드
  static Future<T?> show<T>(
    BuildContext context, {
    bool showKorean = true,
    bool showEnglish = true,
    bool showDescription = false,
    bool showBookmarksOnly = false,
    ValueChanged<bool>? onShowKoreanChanged,
    ValueChanged<bool>? onShowEnglishChanged,
    ValueChanged<bool>? onShowDescriptionChanged,
    ValueChanged<bool>? onShowBookmarksOnlyChanged,
    Color barrierColor = AppColors.black50,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_kBorderRadius),
        ),
      ),
      builder: (_) => LearningDisplaySettingsBottomSheet(
        showKorean: showKorean,
        showEnglish: showEnglish,
        showDescription: showDescription,
        showBookmarksOnly: showBookmarksOnly,
        onShowKoreanChanged: onShowKoreanChanged,
        onShowEnglishChanged: onShowEnglishChanged,
        onShowDescriptionChanged: onShowDescriptionChanged,
        onShowBookmarksOnlyChanged: onShowBookmarksOnlyChanged,
      ),
    );
  }

  @override
  State<LearningDisplaySettingsBottomSheet> createState() =>
      _LearningDisplaySettingsBottomSheetState();
}

class _LearningDisplaySettingsBottomSheetState
    extends State<LearningDisplaySettingsBottomSheet> {
  late bool _showKorean;
  late bool _showEnglish;
  late bool _showDescription;
  late bool _showBookmarksOnly;

  @override
  void initState() {
    super.initState();
    _showKorean = widget.showKorean;
    _showEnglish = widget.showEnglish;
    _showDescription = widget.showDescription;
    _showBookmarksOnly = widget.showBookmarksOnly;
  }

  void _onShowKoreanChanged(bool v) {
    setState(() => _showKorean = v);
    widget.onShowKoreanChanged?.call(v);
  }

  void _onShowEnglishChanged(bool v) {
    setState(() => _showEnglish = v);
    widget.onShowEnglishChanged?.call(v);
  }

  void _onShowDescriptionChanged(bool v) {
    setState(() => _showDescription = v);
    widget.onShowDescriptionChanged?.call(v);
  }

  void _onShowBookmarksOnlyChanged(bool v) {
    setState(() => _showBookmarksOnly = v);
    widget.onShowBookmarksOnlyChanged?.call(v);
  }

  /// 토글 ON → pink600, OFF → gray400
  Color _iconColor(bool isOn) =>
      isOn ? AppColors.pink600 : AppColors.gray400;

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
                  // ── Title ─────────────────────────
                  Text(
                    'Display Settings',
                    style: AppTextStyles.body7B14.copyWith(
                      color: AppColors.pink600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: _kTitleRowGap),
                  // ── Toggle rows ───────────────────
                  _ToggleRow(
                    icon: AppIconAssets.eyeOn,
                    iconColor: _iconColor(_showKorean),
                    label: 'Show Korean',
                    value: _showKorean,
                    onChanged: _onShowKoreanChanged,
                  ),
                  const SizedBox(height: _kRowGap),
                  _ToggleRow(
                    icon: AppIconAssets.eyeOn,
                    iconColor: _iconColor(_showEnglish),
                    label: 'Show English',
                    value: _showEnglish,
                    onChanged: _onShowEnglishChanged,
                  ),
                  const SizedBox(height: _kRowGap),
                  _ToggleRow(
                    icon: AppIconAssets.documentOn,
                    iconColor: _iconColor(_showDescription),
                    label: 'Show Description/patterns',
                    value: _showDescription,
                    onChanged: _onShowDescriptionChanged,
                  ),
                  // ── Divider ───────────────────────
                  const SizedBox(height: _kRowDividerGap),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.gray200,
                  ),
                  const SizedBox(height: _kDividerCheckGap),
                  // ── Bookmark check row ────────────
                  GestureDetector(
                    onTap: () =>
                        _onShowBookmarksOnlyChanged(!_showBookmarksOnly),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _showBookmarksOnly
                              ? AppIconAssets.check1True
                              : AppIconAssets.check1None,
                          width: _kCheckIconSize,
                          height: _kCheckIconSize,
                        ),
                        const SizedBox(width: _kIconLabelGap),
                        Text(
                          'Show Bookmarks Only',
                          style: AppTextStyles.body9Md14.copyWith(
                            color: AppColors.gray900,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: _kBottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────

/// 아이콘 + 라벨 + 소형 토글 한 행
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String icon;

  /// 토글 ON 이면 pink600, OFF 이면 gray400
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: _kToggleIconSize,
          height: _kToggleIconSize,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: _kIconLabelGap),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body9Md14.copyWith(
              color: AppColors.gray900,
              height: 1.2,
            ),
          ),
        ),
        MingoringSwitchToggle(
          value: value,
          onChanged: onChanged,
          size: MingoringSwitchToggleSize.small,
        ),
      ],
    );
  }
}
