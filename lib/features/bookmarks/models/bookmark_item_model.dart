class BookmarkItemModel {
  const BookmarkItemModel({
    required this.bookmarkId,
    required this.originalText,
    required this.translatedText,
    required this.lessonId,
    required this.learningCardId,
    required this.bookmarkedAt,
  });

  final int bookmarkId;
  final String originalText;
  final String translatedText;
  final int lessonId;
  final int learningCardId;
  final DateTime bookmarkedAt;
}

class BookmarkListModel {
  const BookmarkListModel({
    required this.items,
    required this.hasNext,
    required this.totalItems,
  });

  final List<BookmarkItemModel> items;
  final bool hasNext;
  final int totalItems;

  const BookmarkListModel.empty()
      : items = const [],
        hasNext = false,
        totalItems = 0;
}
