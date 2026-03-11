import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/toasts/mingoring_toast.dart';
import '../models/library_item_model.dart';
import '../providers/library_list_provider.dart';
import '../widgets/library_add_video_button.dart';
import '../widgets/library_edit_button.dart';
import '../widgets/library_filter_bar.dart';
import '../widgets/library_list_card.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  LibraryFilterOption _selectedFilter = LibraryFilterOption.all;
  List<LessonItemModel> _cachedItems = const [];

  static const double _horizontalPadding = 20.0;
  static const double _cardSpacing = 12.0;

  LibraryListCardStatus _toCardStatus(LessonStatus status) => switch (status) {
        LessonStatus.uploading => LibraryListCardStatus.uploading,
        LessonStatus.inProgress => LibraryListCardStatus.inProgress,
        LessonStatus.completed => LibraryListCardStatus.completed,
      };

  @override
  Widget build(BuildContext context) {
    final params = LibraryListParams(filter: _selectedFilter);
    final asyncValue = ref.watch(libraryListProvider(params));

    ref.listen(libraryListProvider(params), (_, next) {
      next.whenData((model) {
        setState(() => _cachedItems = model.items);
      });
    });

    return Scaffold(
      backgroundColor: AppColors.pink100,
      floatingActionButton: LibraryAddVideoButton(
        onTap: () => MingoringToast.show(
          context,
          message: 'Coming soon!',
        ),
      ),
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
                onSelected: (option) {
                  setState(() => _selectedFilter = option);
                },
              ),
            ),
            const SizedBox(height: 14),

            // 카드 그리드 (2열)
            Expanded(
              child: _buildBody(asyncValue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AsyncValue<LessonListModel> asyncValue) {
    if (asyncValue.isLoading && _cachedItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError && _cachedItems.isEmpty) {
      debugPrint('[LibraryScreen] error: ${asyncValue.error}');
      debugPrint('[LibraryScreen] stackTrace: ${asyncValue.stackTrace}');
      return Center(
        child: Text(
          'Failed to load library.',
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
    }

    if (_cachedItems.isEmpty) {
      return Center(
        child: Text(
          'No lessons found.',
          style: AppTextStyles.body8Sb14.copyWith(color: AppColors.gray500),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Wrap(
        spacing: _cardSpacing,
        runSpacing: _cardSpacing,
        children: _cachedItems
            .map(
              (item) => LibraryListCard(
                status: _toCardStatus(item.status),
                title: item.title,
                videoTime: item.videoTime,
                thumbnailUrl: item.thumbnailUrl,
                progressRatio: item.progressRatio,
              ),
            )
            .toList(),
      ),
    );
  }
}
