import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class DebugToast {
  static void show(
    BuildContext context, {
    required String message,
  }) {
    if (!kDebugMode) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

