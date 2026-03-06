import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/router/route_paths.dart';
import '../constants/splash_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _mingoScale;
  late final Animation<double> _ringReveal;
  late final Animation<double> _dotPop;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _playSequence();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: SplashConstants.animationDuration,
    );

    _mingoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          SplashConstants.mingoStart,
          SplashConstants.mingoEnd,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _ringReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          SplashConstants.ringStart,
          SplashConstants.ringEnd,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _dotPop = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          SplashConstants.dotStart,
          SplashConstants.dotEnd,
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  Future<void> _playSequence() async {
    await _controller.forward();
    if (!mounted) return;
    await Future.delayed(SplashConstants.holdDuration);
    _navigateToHome();
  }

  void _navigateToHome() {
    if (!mounted) return;
    context.go(RoutePaths.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final logoOffset = Offset(
      0,
      -screenHeight * SplashConstants.logoVerticalOffsetRatio,
    );
    final baseStyle = AppLogoTypography.logo1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Transform.translate(
          offset: logoOffset,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  _buildScaledText(
                    animation: _mingoScale,
                    text: SplashConstants.textMingo,
                    style: baseStyle.copyWith(color: AppColors.pink600),
                  ),
                  _buildRevealText(
                    animation: _ringReveal,
                    text: SplashConstants.textRing,
                    style: baseStyle.copyWith(color: AppColors.gray500),
                  ),
                  _buildScaledText(
                    animation: _dotPop,
                    text: SplashConstants.textDot,
                    style: baseStyle.copyWith(color: AppColors.pink600),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScaledText({
    required Animation<double> animation,
    required String text,
    required TextStyle style,
  }) {
    return Transform.scale(
      scale: animation.value,
      child: Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Text(text, style: style),
      ),
    );
  }

  Widget _buildRevealText({
    required Animation<double> animation,
    required String text,
    required TextStyle style,
  }) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: animation.value,
        child: Text(text, style: style),
      ),
    );
  }
}
