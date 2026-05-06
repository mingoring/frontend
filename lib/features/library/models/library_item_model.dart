enum LessonStatus {
  uploading,
  inProgress,
  completed;

  static LessonStatus fromApiValue(String value) => switch (value) {
        'UPLOADING' => LessonStatus.uploading,
        'IN_PROGRESS' => LessonStatus.inProgress,
        'COMPLETED' => LessonStatus.completed,
        _ => LessonStatus.uploading,
      };
}


class LessonItemModel {
  const LessonItemModel({
    required this.lessonId,
    required this.status,
    required this.title,
    required this.thumbnailUrl,
    required this.progressRatio,
    required this.videoTime,
    required this.addedAt,
    required this.originalText,
    required this.translatedText,
  });

  final int lessonId;
  final LessonStatus status;
  final String title;
  final String? thumbnailUrl;
  final double? progressRatio;
  final String videoTime;
  final DateTime addedAt;
  final String originalText;
  final String translatedText;
}

class LessonListModel {
  const LessonListModel({
    required this.items,
    required this.hasNext,
    required this.totalItems,
  });

  final List<LessonItemModel> items;
  final bool hasNext;
  final int totalItems;

  const LessonListModel.empty()
      : items = const [],
        hasNext = false,
        totalItems = 0;
}
