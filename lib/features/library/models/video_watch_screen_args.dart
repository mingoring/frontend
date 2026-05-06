import 'library_item_model.dart';

/// VideoWatchScreen 진입 시 전달되는 인자
class VideoWatchScreenArgs {
  const VideoWatchScreenArgs({required this.item, required this.videoId});

  final LessonItemModel item;

  /// YouTube 영상 ID (예: 'nM0xDI5R50E')
  final String videoId;
}
