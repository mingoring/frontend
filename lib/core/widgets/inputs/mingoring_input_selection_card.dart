import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../constants/app_typography.dart';

/// [Required] / [Optional] 라벨 표시 방식. 타입 관계없이 사용 가능.
enum InputSelectionCardLabel {
  none,
  required,
  optional,
}

/// 카드 스타일: primary = 전체 동의(accept all), secondary = 개별 항목(single).
enum InputSelectionCardType {
  primary,
  secondary,
}

/// 선택형 입력 카드. primary(전체 동의) / secondary(개별 항목) 타입으로 스타일 구분.
class MingoringInputSelectionCard extends StatelessWidget {
  const MingoringInputSelectionCard({
    super.key,
    required this.type,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.optionalLabel = InputSelectionCardLabel.none,
    this.onViewFullPressed,
  });

  final InputSelectionCardType type;
  final String title;
  final String? subtitle;
  final InputSelectionCardLabel optionalLabel;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onViewFullPressed;

  static const double _borderRadius = 20.0;
  static const double _paddingPrimary = 17.0;
  static const double _paddingSecondary = 16.0;
  static const double _contentGap = 8.0;
  static const double _subtitleGap = 7.0;
  static const double _checkIconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final padding =
        type == InputSelectionCardType.primary ? _paddingPrimary : _paddingSecondary;
    final borderColor = value ? AppColors.pink600 : AppColors.gray400;
    final checkAsset = type == InputSelectionCardType.primary
        ? (value ? AppIconAssets.check2True2 : AppIconAssets.check2None)
        : (value ? AppIconAssets.check2True1 : AppIconAssets.check2None);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    if (subtitle != null) ...[
                      SizedBox(height: type == InputSelectionCardType.primary ? _subtitleGap : _contentGap),
                      Text(
                        subtitle!,
                        style: AppTypography.detail3Md13.copyWith(
                          color: AppColors.gray400,
                          height: 1.2,
                        ),
                      ),
                    ],
                    if (onViewFullPressed != null) ...[
                      SizedBox(height: _contentGap),
                      GestureDetector(
                        onTap: onViewFullPressed,
                        child: Text(
                          'View full',
                          style: AppTypography.detail3Md13.copyWith(
                            color: AppColors.gray400,
                            height: 1.2,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.gray400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: _checkIconSize,
                height: _checkIconSize,
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
          style: AppTypography.head6B18.copyWith(
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
          style: AppTypography.head6B18.copyWith(height: 1.2),
          children: [
            TextSpan(
              text: labelText,
              style: AppTypography.head6B18.copyWith(
                color: labelColor,
                height: 1.2,
              ),
            ),
            TextSpan(
              text: title,
              style: AppTypography.head6B18.copyWith(
                color: AppColors.pink600,
                height: 1.2,
              ),
            ),
          ],
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
        style: AppTypography.body5Sb15.copyWith(height: 1.2),
        children: [
          if (labelText.isNotEmpty)
            TextSpan(
              text: labelText,
              style: AppTypography.body5Sb15.copyWith(
                color: labelColor,
                height: 1.2,
              ),
            ),
          TextSpan(
            text: title,
            style: AppTypography.body5Sb15.copyWith(
              color: bodyColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
