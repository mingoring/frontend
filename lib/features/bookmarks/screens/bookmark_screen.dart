import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../constants/bookmark_constants.dart';
import '../widgets/bookmark_card.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  static const _horizontalPadding = 20.0;
  static const _topSpacing = 16.0;
  static const _cardSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink50,
      appBar: MingoringAppBar(
        type: MingoringBackHeaderType.title,
        text: BookmarkConstants.screenTitle,
        onBack: () => context.pop(),
        backgroundColor: AppColors.pink50,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: _topSpacing),
            Expanded(
              child: ListView.separated(
                itemCount: 0,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: _cardSpacing),
                itemBuilder: (_, index) {
                  return const BookmarkCard(
                    originalText: '',
                    translatedText: '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
