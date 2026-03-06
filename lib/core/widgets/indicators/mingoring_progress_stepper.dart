import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

// 프로그레스 스텝퍼 사이즈
enum MingoringProgressStepperSize {
  small,
  big,
}

// 단계 진행 상태 표시 스텝퍼
class MingoringProgressStepper extends StatelessWidget {
  const MingoringProgressStepper.small({
    super.key,
    required this.maxItemCount, // 전체 스텝 수
    required this.currentItem, // 현재 선택된 스텝 (1-indexed)
  })  : size = MingoringProgressStepperSize.small,
        assert(maxItemCount > 0, 'maxItemCount must be greater than 0'),
        assert(
          currentItem >= 1 && currentItem <= maxItemCount,
          'currentItem must be within [1, maxItemCount]',
        );

  const MingoringProgressStepper.big({
    super.key,
    required this.maxItemCount, // 전체 스텝 수
    required this.currentItem, // 현재 선택된 스텝 (1-indexed)
  })  : size = MingoringProgressStepperSize.big,
        assert(maxItemCount > 0, 'maxItemCount must be greater than 0'),
        assert(
          currentItem >= 1 && currentItem <= maxItemCount,
          'currentItem must be within [1, maxItemCount]',
        ),
        assert(
          maxItemCount == 3,
          'Big MingoringProgressStepper supports maxItemCount == 3 only',
        );

  @visibleForTesting
  final MingoringProgressStepperSize size; // 스텝퍼 사이즈

  final int maxItemCount; // 전체 스텝 수
  final int currentItem; // 현재 단계

  int get _currentIndex => currentItem - 1;

  // Small (Figma: 711:5119)
  static const _smallDotSize = 6.0;
  static const _smallSpacing = 6.0;
  static const _smallAnimationDuration = Duration(milliseconds: 300);

  // Big (Figma: 711:5132)
  static const _bigHeight = 24.0;
  static const _bigWidth = 114.0;
  static const _bigCircleSize = 24.0;
  static const _bigCircleRadius = 12.0;
  static const _bigConnectorWidth = 21.0;
  static const _bigConnectorDotSize = 3.0;
  static const _bigConnectorEdgeGap = 3.0;
  static const _bigConnectorDotGap = 3.0;
  static const _bigTextStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.28,
  );

  static const _bigVariant2CompletedText = Color(0xFFF8EDEC);

  @override
  Widget build(BuildContext context) {
    return switch (size) {
      MingoringProgressStepperSize.small => _SmallProgressStepper(
        itemCount: maxItemCount,
        currentIndex: _currentIndex,
      ),
      MingoringProgressStepperSize.big => _BigProgressStepper(
        currentIndex: _currentIndex,
      ),
    };
  }
}

class _SmallProgressStepper extends StatelessWidget {
  const _SmallProgressStepper({
    required this.itemCount,
    required this.currentIndex,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: MingoringProgressStepper._smallAnimationDuration,
          margin: const EdgeInsets.symmetric(
            horizontal: MingoringProgressStepper._smallSpacing / 2,
          ),
          width: MingoringProgressStepper._smallDotSize,
          height: MingoringProgressStepper._smallDotSize,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pink600 : AppColors.gray300,
            borderRadius: BorderRadius.circular(
              MingoringProgressStepper._smallDotSize / 2,
            ),
          ),
        );
      }),
    );
  }
}

class _BigProgressStepper extends StatelessWidget {
  const _BigProgressStepper({
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MingoringProgressStepper._bigWidth,
      height: MingoringProgressStepper._bigHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepCircle(
            index: 0,
            currentIndex: currentIndex,
          ),
          _ConnectorDots(isActive: currentIndex > 0),
          _StepCircle(
            index: 1,
            currentIndex: currentIndex,
          ),
          _ConnectorDots(isActive: currentIndex > 1),
          _StepCircle(
            index: 2,
            currentIndex: currentIndex,
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.currentIndex,
  });

  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final isCompleted = index < currentIndex;

    final Color borderColor;
    final Color? fillColor;
    final Color textColor;

    if (isActive) {
      borderColor = AppColors.pink600;
      fillColor = AppColors.pink600;
      textColor = AppColors.white;
    } else if (isCompleted) {
      borderColor = AppColors.pink300;
      fillColor = AppColors.pink300;
      textColor = (currentIndex == 1 && index == 0)
          ? MingoringProgressStepper._bigVariant2CompletedText
          : AppColors.pink100;
    } else {
      borderColor = AppColors.gray400;
      fillColor = null;
      textColor = AppColors.gray400;
    }

    return SizedBox.square(
      dimension: MingoringProgressStepper._bigCircleSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(
            MingoringProgressStepper._bigCircleRadius,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: MingoringProgressStepper._bigTextStyle.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectorDots extends StatelessWidget {
  const _ConnectorDots({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final dotColor = isActive ? AppColors.pink300 : AppColors.gray400;

    Widget dot() => SizedBox.square(
      dimension: MingoringProgressStepper._bigConnectorDotSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dotColor,
          borderRadius: BorderRadius.circular(
            MingoringProgressStepper._bigConnectorDotSize / 2,
          ),
        ),
      ),
    );

    return SizedBox(
      width: MingoringProgressStepper._bigConnectorWidth,
      height: MingoringProgressStepper._bigHeight,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: MingoringProgressStepper._bigConnectorEdgeGap),
            dot(),
            const SizedBox(width: MingoringProgressStepper._bigConnectorDotGap),
            dot(),
            const SizedBox(width: MingoringProgressStepper._bigConnectorDotGap),
            dot(),
            const SizedBox(width: MingoringProgressStepper._bigConnectorEdgeGap),
          ],
        ),
      ),
    );
  }
}

