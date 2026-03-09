import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/onboarding/screens/login_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/signup_screen.dart';
import '../../features/onboarding/screens/terms_agreement_screen.dart';
import '../../features/profile/screens/my_page_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../widgets/layouts/mingoring_navigation_bar.dart';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: MingoringNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.library,
              builder: (_, __) => const LibraryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (_, __) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.myPage,
              builder: (_, __) => const MyPageScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
