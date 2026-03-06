import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../constants/app_typography.dart';

// 검증 전용 텍스트 필드 상태
enum MingoringInputTextfieldVerifyState {
  defaultState,
  typing,
  active,
  filled,
  error,
}

// 검증 기능이 포함된 표준 텍스트 입력 위젯.
class MingoringInputTextfieldVerify extends StatelessWidget {
  const MingoringInputTextfieldVerify({
    super.key,
    required this.controller, // 텍스트 컨트롤러
    this.hintText = '', // 힌트 텍스트
    this.state = MingoringInputTextfieldVerifyState.defaultState, // 필드 상태
    this.showMax = false, // 글자 수 카운터 표시 여부
    this.maxLength, // 최대 글자 수
    this.leadingIconAsset, // 앞쪽 아이콘 에셋 경로
    this.onChanged, // 입력 변경 콜백
    this.onSubmitted, // 입력 완료 콜백
    this.keyboardType, // 키보드 타입
    this.textInputAction, // 키보드 액션 버튼
    this.enabled = true, // 활성화 여부
    this.helperText, // 도움말 텍스트
  }) : assert(
          showMax == false || maxLength != null,
          'maxLength is required when showMax is true',
        );

  final TextEditingController controller; // 텍스트 컨트롤러
  final String hintText; // 힌트 텍스트
  final MingoringInputTextfieldVerifyState state; // 필드 상태
  final bool showMax; // 글자 수 카운터 표시 여부
  final int? maxLength; // 최대 글자 수
  final String? leadingIconAsset; // 앞쪽 아이콘 에셋 경로
  final ValueChanged<String>? onChanged; // 입력 변경 콜백
  final ValueChanged<String>? onSubmitted; // 입력 완료 콜백
  final TextInputType? keyboardType; // 키보드 타입
  final TextInputAction? textInputAction; // 키보드 액션 버튼
  final bool enabled; // 활성화 여부
  final String? helperText; // 도움말 텍스트

  static const double _borderRadius = 20.0;
  static const double _height = 50.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 14.0;
  static const double _iconSize = 16.0;
  static const double _contentGapDefault = 10.0;
  static const double _contentGapDense = 7.0;
  static const double _helperGap = 8.0;

  bool get _isError => state == MingoringInputTextfieldVerifyState.error;

  bool get _isActiveBorder =>
      state == MingoringInputTextfieldVerifyState.active ||
      state == MingoringInputTextfieldVerifyState.typing;

  bool get _showTrailingCheckTrue =>
      state == MingoringInputTextfieldVerifyState.active;

  bool get _showTrailingCheckFalse =>
      state == MingoringInputTextfieldVerifyState.typing ||
      state == MingoringInputTextfieldVerifyState.filled ||
      state == MingoringInputTextfieldVerifyState.error;

  Color get _borderColor {
    if (_isError) return AppColors.pink600;
    if (_isActiveBorder) return AppColors.pink600;
    return AppColors.gray400;
  }

  Color get _backgroundColor {
    if (_isError) return AppColors.pink200;
    return AppColors.white;
  }

  Color get _textColor {
    if (_isError) return AppColors.pink600;
    return AppColors.black;
  }

  @override
  Widget build(BuildContext context) {
    final hasHelperOrCounter = helperText != null || showMax;

    final field = Container(
      height: _height,
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadingIconAsset != null) ...[
            _buildLeadingIcon(),
            SizedBox(
              width: _isError || _isActiveBorder
                  ? _contentGapDense
                  : _contentGapDefault,
            ),
          ],
          Expanded(
            child: _buildTextField(),
          ),
          if (_showTrailingCheckTrue || _showTrailingCheckFalse) ...[
            const SizedBox(width: _contentGapDense),
            _buildTrailingIcon(),
          ],
        ],
      ),
    );

    if (!hasHelperOrCounter) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        field,
        const SizedBox(height: _helperGap),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final currentLength = value.text.characters.length;
            return _buildHelperAndCounter(currentLength);
          },
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      style: AppTypography.body9Md14.copyWith(
        color: _textColor,
        height: 1.2,
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: hintText,
        hintStyle: AppTypography.body9Md14.copyWith(
          color: AppColors.gray400,
          height: 1.2,
        ),
        counterText: '',
        isDense: true,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  Widget _buildLeadingIcon() {
    final asset = leadingIconAsset!;
    final icon = asset.endsWith('.svg')
        ? SvgPicture.asset(
            asset,
            width: _iconSize,
            height: _iconSize,
          )
        : Image.asset(
            asset,
            width: _iconSize,
            height: _iconSize,
          );

    return SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: Center(child: icon),
    );
  }

  Widget _buildTrailingIcon() {
    final String assetPath;
    if (_showTrailingCheckTrue) {
      assetPath = AppIconAssets.check1True;
    } else {
      assetPath = AppIconAssets.check1False;
    }

    final icon = SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: SvgPicture.asset(
        assetPath,
        width: _iconSize,
        height: _iconSize,
      ),
    );

    if (_showTrailingCheckFalse) {
      return GestureDetector(
        onTap: () {
          controller.clear();
          onChanged?.call('');
        },
        child: icon,
      );
    }

    return icon;
  }

  Widget _buildHelperAndCounter(int currentLength) {
    final counterText =
        showMax && maxLength != null ? '$currentLength/$maxLength' : null;

    if (helperText == null && counterText == null) {
      return const SizedBox.shrink();
    }

    final helperStyle = AppTypography.detail6Md12.copyWith(
      color: AppColors.pink600,
      height: 1.4,
    );

    final counterStyle = helperStyle;

    if (helperText != null && counterText != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            helperText!,
            style: helperStyle,
          ),
          Text(
            counterText,
            style: counterStyle,
          ),
        ],
      );
    }

    if (helperText != null) {
      return Text(
        helperText!,
        style: helperStyle,
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        counterText!,
        style: counterStyle,
      ),
    );
  }
}

