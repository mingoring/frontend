import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

// stepper 사이즈
enum MingoringProgressStepperSize { 
  small,
  big
}

// 프로그레스 스텝퍼
class MingoringProgressStepper extends StatelessWidget {
  const MingoringProgressStepper.small({
    super.key,
    required this.currentIndex,
  }) : size = MingoringProgressStepperSize.small,
       assert(currentIndex >= 0 && currentIndex < stepCount);

  const MingoringProgressStepper.big({
    super.key,
    required this.currentIndex,
  }) : size = MingoringProgressStepperSize.big,
       assert(currentIndex >= 0 && currentIndex < stepCount);

  // 3단계 고정
  static const stepCount = 3;

  @visibleForTesting
  final MingoringProgressStepperSize size;

  // 현재 단계 (0-indexed)
  final int currentIndex;

  // ── Small 상수 ──────────────────────────────────────
  static const _smallDotSize = 6.0;
  static const _smallSpacing = 6.0;
  static const _smallAnimDuration = Duration(milliseconds: 300);

  // ── Big 상수 ────────────────────────────────────────
  static const _bigHeight = 24.0;
  static const _bigWidth = 114.0;
  static const _bigCircleSize = 24.0;
  static const _bigConnectorWidth = 21.0;
  static const _bigConnectorDotSize = 3.0;
  static const _bigConnectorEdgeGap = 3.0;
  static const _bigConnectorDotGap = 3.0;

  @override
  Widget build(BuildContext context) {
    return switch (size) {
      MingoringProgressStepperSize.small => _SmallStepper(
        currentIndex: currentIndex,
      ),
      MingoringProgressStepperSize.big => _BigStepper(
        currentIndex: currentIndex,
      ),
    };
  }
}

// =====================================================================
// Small
// =====================================================================

class _SmallStepper extends StatelessWidget {
  const _SmallStepper({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(MingoringProgressStepper.stepCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: MingoringProgressStepper._smallAnimDuration,
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

// =====================================================================
// Big
// =====================================================================

class _BigStepper extends StatelessWidget {
  const _BigStepper({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MingoringProgressStepper._bigWidth,
      height: MingoringProgressStepper._bigHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepCircle(index: 0, currentIndex: currentIndex),
          _ConnectorDots(isActive: currentIndex > 0),
          _StepCircle(index: 1, currentIndex: currentIndex),
          _ConnectorDots(isActive: currentIndex > 1),
          _StepCircle(index: 2, currentIndex: currentIndex),
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
      textColor = AppColors.pink100;
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
            MingoringProgressStepper._bigCircleSize / 2,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: AppTypography.body7B14.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class _ConnectorDots extends StatelessWidget {
  const _ConnectorDots({required this.isActive});

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
      child: Center(
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
