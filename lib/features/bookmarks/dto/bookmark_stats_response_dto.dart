class BookmarkStatsResponseDto {
  const BookmarkStatsResponseDto({required this.count});

  final int count;

  factory BookmarkStatsResponseDto.fromJson(Map<String, dynamic> json) {
    return BookmarkStatsResponseDto(count: json['count'] as int);
  }
}
