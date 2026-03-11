class BookmarkStatsModel {
  const BookmarkStatsModel({required this.count});

  final int count;

  const BookmarkStatsModel.empty() : count = 0;

  bool get isEmpty => count == 0;
}
