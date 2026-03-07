import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/terms_agreement_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_paths.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: RoutePaths.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePaths.terms,
      builder: (_, __) => const TermsAgreementScreen(),
    ),
    GoRoute(
      path: RoutePaths.signup,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (_, __) => const HomeScreen(),
    ),
  ],
);
