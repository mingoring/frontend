import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/screens/login_screen.dart';
import '../../features/onboarding/screens/signup_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/terms_agreement_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.splash,
  routes: <RouteBase>[
    GoRoute(
      path: RouteNames.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.terms,
      builder: (_, __) => const TermsAgreementScreen(),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.home,
      builder: (_, __) => const HomeScreen(),
    ),
  ],
);
