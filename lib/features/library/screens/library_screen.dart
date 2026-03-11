import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/library_edit_button.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.all;

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Edit 버튼 (우측 정렬)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _horizontalPadding,
                16,
                _horizontalPadding,
                0,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: LibraryEditButton(onTap: () {}),
              ),
            ),
            const SizedBox(height: 20),

            // 타이틀 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Library',
                    style: AppLogoTypography.logoB4.copyWith(
                      color: AppColors.pink600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add videos and enjoy in this section!',
                    style: AppTextStyles.body8Sb14.copyWith(
                      color: AppColors.gray500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 필터 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: LibraryFilterBar(
                selectedOption: _selectedFilter,
                onSelected: (option) =>
                    setState(() => _selectedFilter = option),
              ),
            ),
            const SizedBox(height: 14),

            // 카드 그리드 (2열)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Wrap(
                  spacing: _cardSpacing,
                  runSpacing: _cardSpacing,
                  children: [
                    LibraryListCard(
                      status: LibraryListCardStatus.uploading,
                      title: 'BLACKPINK ROSÉ\'s Honest Puzzle Interview 🧩',
                      videoTime: '13:44',
                    ),
                    LibraryListCard(
                      status: LibraryListCardStatus.uploading,
                      title: 'BLACKPINK ROSÉ\'s Honest Puzzle Interview 🧩',
                      videoTime: '13:44',
                    ),
                    LibraryListCard(
                      status: LibraryListCardStatus.inProgress,
                      title: 'BLACKPINK ROSÉ\'s Honest Puzzle Interview 🧩',
                      videoTime: '17:32',
                      progressRatio: 0.3,
                    ),
                    LibraryListCard(
                      status: LibraryListCardStatus.completed,
                      title: 'BLACKPINK ROSÉ\'s Honest Puzzle Interview 🧩',
                      videoTime: '43:34',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
