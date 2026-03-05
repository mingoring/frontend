import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../presentation/screens/test_screen.dart';

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

  // Duration
  static const _animationDuration = Duration(milliseconds: 1400);
  static const _holdDuration = Duration(milliseconds: 400);
  static const _transitionDuration = Duration(milliseconds: 500);

  // 화면 높이 대비 로고 상단 이동 비율
  static const _logoVerticalOffsetRatio = 0.04;

  // Animation intervals
  static const _mingoStart = 0.0;
  static const _mingoEnd = 0.35;
  static const _ringStart = 0.20;
  static const _ringEnd = 0.75;
  static const _dotStart = 0.65;
  static const _dotEnd = 1.0;

  // Logo text segments
  static const _textMingo = 'mingo';
  static const _textRing = 'ring';
  static const _textDot = ' .';

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _playSequence();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _mingoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_mingoStart, _mingoEnd, curve: Curves.easeOutBack),
      ),
    );

    _ringReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_ringStart, _ringEnd, curve: Curves.elasticOut),
      ),
    );

    _dotPop = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(_dotStart, _dotEnd, curve: Curves.bounceOut),
      ),
    );
  }

  Future<void> _playSequence() async {
    await _controller.forward();
    if (!mounted) return;
    await Future.delayed(_holdDuration);
    _navigateToHome();
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TestScreen(),
        transitionDuration: _transitionDuration,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final logoOffset = Offset(0, -screenHeight * _logoVerticalOffsetRatio);
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
                    text: _textMingo,
                    style: baseStyle.copyWith(color: AppColors.pink600),
                  ),
                  _buildRevealText(
                    animation: _ringReveal,
                    text: _textRing,
                    style: baseStyle.copyWith(color: AppColors.gray500),
                  ),
                  _buildScaledText(
                    animation: _dotPop,
                    text: _textDot,
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
