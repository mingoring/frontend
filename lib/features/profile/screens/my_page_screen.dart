import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage_service.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../../auth/providers/auth_provider.dart';
import '../../onboarding/constants/signup_screen_constants.dart';
import '../../onboarding/providers/signup_provider.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  static const _termLabels = [
    'Terms of Service',
    'Privacy Policy',
    'Push Notifications',
    'Marketing',
  ];

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authNotifierProvider.notifier).signOut();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupNotifierProvider);
    final response = state.signupResponse;
    final savedNickname = ref
        .watch(localStorageServiceProvider)
        .valueOrNull
        ?.getNickname();

    return Scaffold(
      appBar: const MingoringAppBar.titleOnly(text: 'My Page'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('회원가입 입력 정보'),
              _InfoRow('닉네임', savedNickname ?? state.nickname ?? '-'),
              _InfoRow(
                '레벨',
                state.level != null
                    ? SignupScreenConstants.levelOptions[state.level! - 1].title
                    : '-',
              ),
              _InfoRow(
                '관심분야',
                state.interestCodes?.isNotEmpty == true
                    ? state.interestCodes!
                        .map((code) {
                          final idx = SignupScreenConstants.interestCodes
                              .indexOf(code);
                          return idx >= 0
                              ? SignupScreenConstants.interestOptions[idx]
                              : code;
                        })
                        .join(', ')
                    : '-',
              ),
              _InfoRow('추천인 코드', state.referralCode ?? '-'),
              const SizedBox(height: 24),
              _SectionTitle('약관 동의'),
              for (int i = 0; i < state.termAgreements.length; i++)
                _InfoRow(
                  _termLabels[i],
                  state.termAgreements[i] ? '동의' : '미동의',
                ),
              if (response != null) ...[
                const SizedBox(height: 24),
                _SectionTitle('서버 응답'),
                _InfoRow('userId', '${response.userId}'),
                _InfoRow('accessToken', response.accessToken),
                _InfoRow('refreshToken', response.refreshToken),
                _InfoRow('Referral Code Status', response.referralCodeStatus),
              ],
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => _handleSignOut(context, ref),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
