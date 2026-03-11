abstract final class BookmarkConstants {
  static const String screenTitle = 'Bookmarks';
  static const String screenSubtitle = 'Sentences you saved from videos.';
  static const String searchHint = 'Search';
  static const String bookmarkCountSuffix = 'Bookmarks';
  static const String emptyTitle = 'Add Bookmarks';
  static const String emptySubtitle =
      'Save sentences to review later.\nFind them here anytime.';
  static const String goLibraryButton = 'Go Library';
  static const String copiedToClipboard = 'Copied to clipboard!';
}

enum BookmarkSortType {
  newest,
  oldest;

  String get label => switch (this) {
        BookmarkSortType.newest => 'Newest',
        BookmarkSortType.oldest => 'Oldest',
      };

  String get apiValue => switch (this) {
        BookmarkSortType.newest => 'NEWEST',
        BookmarkSortType.oldest => 'OLDEST',
      };
}
