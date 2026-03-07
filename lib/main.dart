import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/errors/app_exception.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/dialogs/error_popup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    final error = details.exception;
    if (error is AppException) {
      _showGlobalErrorPopup(error.message);
    } else {
      FlutterError.presentError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (error is AppException) {
      _showGlobalErrorPopup(error.message);
      return true;
    }
    return false;
  };

  runApp(const ProviderScope(child: MyApp()));
}

void _showGlobalErrorPopup(String message) {
  final ctx = navigatorKey.currentContext;
  if (ctx == null) return;
  ErrorPopup.show(ctx, errorMessage: message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mingoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink600),
        scaffoldBackgroundColor: AppColors.white,
      ),
      routerConfig: appRouter,
    );
  }
}
