import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../theme/app_text_styles.dart';

// 입력 카드 타입 (타입에 따라 디자인 다름)
enum InputSelectionCardType {
  primary,
  secondary,
  compact,
}

// 라벨 표시 여부 ([Required], [Optional] 텍스트)
enum InputSelectionCardLabel {
  none,
  required,
  optional,
}

// 링크 텍스트 버튼 노출 여부 (viewFull 버튼)
enum InputSelectionCardLinkButton {
  none,
  viewFull,
}

class MingoringInputSelectionCard extends StatelessWidget {
  const MingoringInputSelectionCard({
    super.key,
    required this.type,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.optionalLabel = InputSelectionCardLabel.none,
    this.linkButton = InputSelectionCardLinkButton.none,
    this.linkText = 'View full',
    this.onLinkPressed,
  }) : assert(
          linkButton != InputSelectionCardLinkButton.viewFull ||
              onLinkPressed != null,
          'onLinkPressed is required when linkButton is viewFull',
        );

  final InputSelectionCardType type; // 카드 타입
  final String title; // 카드 제목
  final String? subtitle; // 카드 부제목
  final InputSelectionCardLabel optionalLabel; // 라벨 표시 여부
  final InputSelectionCardLinkButton linkButton; // 링크 버튼 노출 여부
  final String linkText; // 링크 텍스트
  final bool value; // 선택 여부
  final ValueChanged<bool> onChanged; // 변경 콜백
  final VoidCallback? onLinkPressed; // 링크 클릭 콜백

  static const double _borderRadius = 20.0;
  static const double _paddingPrimary = 17.0;
  static const double _paddingSecondary = 16.0;
  static const double _contentGap = 8.0;
  static const double _subtitleGap = 7.0;
  static const double _checkIconSize = 24.0;
  static const double _checkIconSizeCompact = 16.0;
  static const double _subtitleGapCompact = 3.0;
  static const EdgeInsets _paddingCompact =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0);
  static const double _linkHitAreaHorizontalPadding = 8.0;
  static const double _linkHitAreaVerticalPadding = 4.0;

  @override
  Widget build(BuildContext context) {
    final isCompact = type == InputSelectionCardType.compact;
    final edgeInsets = isCompact
        ? _paddingCompact
        : EdgeInsets.all(type == InputSelectionCardType.primary
            ? _paddingPrimary
            : _paddingSecondary);
    final borderColor = value ? AppColors.pink600 : AppColors.gray400;
    final checkAsset = isCompact
        ? (value ? AppIconAssets.check1True : AppIconAssets.check1None)
        : type == InputSelectionCardType.primary
            ? (value ? AppIconAssets.check2True2 : AppIconAssets.check2None)
            : (value ? AppIconAssets.check2True1 : AppIconAssets.check2None);
    final iconSize = isCompact ? _checkIconSizeCompact : _checkIconSize;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          padding: edgeInsets,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: isCompact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    if (subtitle != null) ...[
                      SizedBox(
                          height: isCompact
                              ? _subtitleGapCompact
                              : type == InputSelectionCardType.primary
                                  ? _subtitleGap
                                  : _contentGap),
                      Text(
                        subtitle!,
                        style: AppTextStyles.detail3Md13.copyWith(
                          color: AppColors.gray400,
                          height: 1.2,
                        ),
                      ),
                    ],
                    if (linkButton ==
                        InputSelectionCardLinkButton.viewFull) ...[
                      SizedBox(height: _contentGap),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onLinkPressed,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: _linkHitAreaHorizontalPadding,
                            top: _linkHitAreaVerticalPadding,
                            bottom: _linkHitAreaVerticalPadding,
                          ),
                          child: Text(
                            linkText,
                            style: AppTextStyles.detail3Md13.copyWith(
                              color: AppColors.gray400,
                              height: 1.2,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gray400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: SvgPicture.asset(
                  checkAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (type == InputSelectionCardType.primary) {
      if (optionalLabel == InputSelectionCardLabel.none) {
        return Text(
          title,
          style: AppTextStyles.head6B18.copyWith(
            color: AppColors.pink600,
            height: 1.2,
          ),
        );
      }
      final labelText = optionalLabel == InputSelectionCardLabel.required
          ? '[Required] '
          : '[Optional] ';
      final labelColor = optionalLabel == InputSelectionCardLabel.required
          ? AppColors.pink600
          : AppColors.gray600;
      return RichText(
        text: TextSpan(
          style: AppTextStyles.head6B18.copyWith(height: 1.2),
          children: [
            TextSpan(
              text: labelText,
              style: AppTextStyles.head6B18.copyWith(
                color: labelColor,
                height: 1.2,
              ),
            ),
            TextSpan(
              text: title,
              style: AppTextStyles.head6B18.copyWith(
                color: AppColors.pink600,
                height: 1.2,
              ),
            ),
          ],
        ),
      );
    }

    if (type == InputSelectionCardType.compact) {
      final bodyColor = value ? AppColors.pink600 : AppColors.black;
      return Text(
        title,
        style: AppTextStyles.body4B15.copyWith(
          color: bodyColor,
          height: 1.2,
        ),
      );
    }

    final labelText = switch (optionalLabel) {
      InputSelectionCardLabel.required => '[Required] ',
      InputSelectionCardLabel.optional => '[Optional] ',
      InputSelectionCardLabel.none => '',
    };
    final labelColor = optionalLabel == InputSelectionCardLabel.required
        ? AppColors.pink600
        : AppColors.gray600;
    final bodyColor = value ? AppColors.black : AppColors.gray600;

    return RichText(
      text: TextSpan(
        style: AppTextStyles.body5Sb15.copyWith(height: 1.2),
        children: [
          if (labelText.isNotEmpty)
            TextSpan(
              text: labelText,
              style: AppTextStyles.body5Sb15.copyWith(
                color: labelColor,
                height: 1.2,
              ),
            ),
          TextSpan(
            text: title,
            style: AppTextStyles.body5Sb15.copyWith(
              color: bodyColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
