import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../constants/app_typography.dart';

// 검증 결과 상태
enum MingoringValidationStatus {
  none,
  success,
  error,
}

// trailing 아이콘 타입 (위젯 내부 전용)
enum _TrailingIconType {
  none,
  checkTrue,
  checkFalse,
}

// 검증 기능이 포함된 표준 텍스트 입력 위젯.
class MingoringInputTextfieldVerify extends StatefulWidget {
  const MingoringInputTextfieldVerify({
    super.key,
    required this.controller, // 텍스트 컨트롤러
    this.hintText = '', // 힌트 텍스트
    this.validationStatus = MingoringValidationStatus.none, // 검증 상태
    this.showMax = false, // 글자 수 카운터 표시 여부
    this.maxLength, // 최대 글자 수
    this.leadingIconAsset, // 앞쪽 아이콘 에셋 경로
    this.onChanged, // 입력 변경 콜백
    this.onSubmitted, // 입력 완료 콜백
    this.keyboardType, // 키보드 타입
    this.textInputAction, // 키보드 액션 버튼
    this.enabled = true, // 활성화 여부
    this.helperText, // 도움말 텍스트
    this.focusNode, // 포커스 노드
  }) : assert(
          showMax == false || maxLength != null,
          'maxLength is required when showMax is true',
        );

  final TextEditingController controller;
  final String hintText;
  final MingoringValidationStatus validationStatus;
  final bool showMax;
  final int? maxLength;
  final String? leadingIconAsset;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final String? helperText;
  final FocusNode? focusNode;

  @override
  State<MingoringInputTextfieldVerify> createState() => _MingoringInputTextfieldVerifyState();
}

class _MingoringInputTextfieldVerifyState extends State<MingoringInputTextfieldVerify> {
  late final FocusNode _internalFocusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
    _hasText = widget.controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant MingoringInputTextfieldVerify oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
      _hasText = widget.controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChanged);
    widget.controller.removeListener(_onTextChanged);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _internalFocusNode.hasFocus);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  static const double _borderRadius = 20.0;
  static const double _height = 50.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 14.0;
  static const double _iconSize = 16.0;
  static const double _contentGapDefault = 10.0;
  static const double _contentGapDense = 7.0;
  static const double _helperGap = 8.0;

  // ── 내부 계산 getters ─────────────────────────────
  bool get _isError => widget.validationStatus == MingoringValidationStatus.error;

  bool get _showOutline =>
      _isFocused ||
      widget.validationStatus == MingoringValidationStatus.success ||
      _isError;

  bool get _showErrorBackground => _isError;

  _TrailingIconType get _trailingIconType {
    if (!_hasText) return _TrailingIconType.none;
    if (widget.validationStatus == MingoringValidationStatus.success) {
      return _TrailingIconType.checkTrue;
    }
    return _TrailingIconType.checkFalse;
  }

  bool get _hasTrailingIcon => _trailingIconType != _TrailingIconType.none;

  Color get _borderColor {
    if (_isError) return AppColors.pink600;
    if (_showOutline) return AppColors.pink600;
    return AppColors.gray400;
  }

  Color get _backgroundColor {
    if (_showErrorBackground) return AppColors.pink200;
    return AppColors.white;
  }

  Color get _textColor {
    if (_isError) return AppColors.pink600;
    return AppColors.black;
  }

  @override
  Widget build(BuildContext context) {
    final hasHelperOrCounter = widget.helperText != null || widget.showMax;

    final field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // TextField 영역 전체를 눌렀을 때 포커스 요청 (아이콘 터치 영역 외 전체)
        if (widget.enabled) {
          FocusScope.of(context).requestFocus(_internalFocusNode);
        }
      },
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(color: _borderColor),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
                vertical: _verticalPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leadingIconAsset != null) ...[
                    _buildLeadingIcon(),
                    SizedBox(
                      width: _isError || _showOutline
                          ? _contentGapDense
                          : _contentGapDefault,
                    ),
                  ],
                  Expanded(
                    child: _buildTextField(),
                  ),
                  if (_hasTrailingIcon)
                    const SizedBox(width: _contentGapDense + _iconSize),
                ],
              ),
            ),
            if (_hasTrailingIcon)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: _buildTrailingIcon(),
              ),
          ],
        ),
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
          valueListenable: widget.controller,
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
      controller: widget.controller,
      focusNode: _internalFocusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
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
        hintText: widget.hintText,
        hintStyle: AppTypography.body9Md14.copyWith(
          color: AppColors.gray400,
          height: 1.2,
        ),
        counterText: '',
        isDense: true,
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }

  Widget _buildLeadingIcon() {
    final asset = widget.leadingIconAsset!;
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
    if (_trailingIconType == _TrailingIconType.checkTrue) {
      assetPath = AppIconAssets.check1True;
    } else {
      assetPath = AppIconAssets.check1False;
    }

    final icon = Center(
      child: SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: SvgPicture.asset(
          assetPath,
          width: _iconSize,
          height: _iconSize,
        ),
      ),
    );

    // 삭제 버튼 터치 영역 (아이콘 시작 x좌표부터 우측 끝 지정)
    final touchAreaWidth = _iconSize + _horizontalPadding;

    final touchArea = Container(
      width: touchAreaWidth,
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: _horizontalPadding),
      child: icon,
    );

    if (_trailingIconType == _TrailingIconType.checkFalse) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.controller.clear();
          widget.onChanged?.call('');
        },
        child: touchArea,
      );
    }

    return touchArea;
  }

  Widget _buildHelperAndCounter(int currentLength) {
    final counterText =
        widget.showMax && widget.maxLength != null ? '$currentLength/${widget.maxLength}' : null;

    if (widget.helperText == null && counterText == null) {
      return const SizedBox.shrink();
    }

    final helperStyle = AppTypography.detail6Md12.copyWith(
      color: AppColors.pink600,
      height: 1.4,
    );

    final counterStyle = helperStyle;

    if (widget.helperText != null && counterText != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.helperText!,
            style: helperStyle,
          ),
          Text(
            counterText,
            style: counterStyle,
          ),
        ],
      );
    }

    if (widget.helperText != null) {
      return Text(
        widget.helperText!,
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
