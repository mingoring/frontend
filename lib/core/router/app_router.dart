import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/bookmarks/screens/bookmark_entry_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/calendar_screen.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/onboarding/screens/login_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/signup_screen.dart';
import '../../features/onboarding/screens/terms_agreement_screen.dart';
import '../../features/profile/screens/my_page_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../widgets/layouts/mingoring_navigation_bar.dart';
import 'route_names.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final onboardingFlag = ref.read(onboardingNotifierProvider);
      final location = state.matchedLocation;

      if (authState is AuthStateLoading) {
        return location == RouteNames.splash ? null : RouteNames.splash;
      }

      // 인증 없을 때 온보딩 완료 여부에 따른 라우팅 결정
      final unauthDestination =
          onboardingFlag ? RouteNames.login : RouteNames.onboarding;

      return switch (authState) {
        AuthStateLoading() => null,
        AuthStateAuthenticated() =>
          _isAuthRoute(location) ? RouteNames.home : null,
        AuthStateUnauthenticated() =>
          _isProtectedRoute(location) ? unauthDestination : null,
        AuthStateGuest() => _isAuthRoute(location) ? RouteNames.home : null,
      };
    },
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
        path: RouteNames.calendar,
        builder: (_, __) => const CalendarScreen(),
      ),
      GoRoute(
        path: RouteNames.bookmarks,
        builder: (_, __) => const BookmarkEntryScreen(),
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

  // AuthState 변경 감지 → 라우터 갱신
  ref.listen<AuthState>(authNotifierProvider, (_, __) => router.refresh());

  return router;
}

bool _isAuthRoute(String location) =>
    location == RouteNames.login ||
    location == RouteNames.onboarding ||
    location == RouteNames.terms ||
    location == RouteNames.signup;

bool _isProtectedRoute(String location) =>
    location == RouteNames.home ||
    location == RouteNames.library ||
    location == RouteNames.myPage ||
    location == RouteNames.calendar ||
    location == RouteNames.bookmarks;
