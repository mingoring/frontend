import '../models/bookmark_item_model.dart';

class BookmarkItemDto {
  const BookmarkItemDto({
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
  final String bookmarkedAt;

  factory BookmarkItemDto.fromJson(Map<String, dynamic> json) {
    return BookmarkItemDto(
      bookmarkId: json['bookmarkId'] as int,
      originalText: json['originalText'] as String,
      translatedText: json['translatedText'] as String,
      lessonId: json['lessonId'] as int,
      learningCardId: json['learningCardId'] as int,
      bookmarkedAt: json['bookmarkedAt'] as String,
    );
  }

  BookmarkItemModel toModel() {
    return BookmarkItemModel(
      bookmarkId: bookmarkId,
      originalText: originalText,
      translatedText: translatedText,
      lessonId: lessonId,
      learningCardId: learningCardId,
      bookmarkedAt: DateTime.parse(bookmarkedAt),
    );
  }
}

class BookmarkListResponseDto {
  const BookmarkListResponseDto({
    required this.items,
    required this.hasNext,
    required this.totalItems,
  });

  final List<BookmarkItemDto> items;
  final bool hasNext;
  final int totalItems;

  factory BookmarkListResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final paging = json['paging'] as Map<String, dynamic>? ?? {};
    return BookmarkListResponseDto(
      items: rawItems
          .map((e) => BookmarkItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: paging['hasNext'] as bool? ?? false,
      totalItems: paging['totalItems'] as int? ?? 0,
    );
  }

  BookmarkListModel toModel() {
    return BookmarkListModel(
      items: items.map((e) => e.toModel()).toList(),
      hasNext: hasNext,
      totalItems: totalItems,
    );
  }
}
