import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage_service.dart';
import '../../../core/widgets/layouts/gradient_background.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../../onboarding/providers/signup_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupNotifierProvider);
    final savedNickname = ref
        .watch(localStorageServiceProvider)
        .valueOrNull
        ?.getNickname();

    return Scaffold(
      appBar: const MingoringAppBar.titleOnly(text: 'Home'),
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('닉네임: ${savedNickname ?? state.nickname ?? '-'}'),
          ),
        ),
      ),
    );
  }
}
