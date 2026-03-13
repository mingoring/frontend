import '../models/library_item_model.dart';

/// LibraryScreen -> LibraryEditScreen 이동 시 전달하는 편집용 스냅샷
///
/// - [initialItems]: 편집 화면의 원본 기준이 되는 전체 아이템 목록
class LibraryEditScreenArgs {
  LibraryEditScreenArgs({
    required List<LessonItemModel> initialItems,
  }) : initialItems = List.unmodifiable(initialItems);

  final List<LessonItemModel> initialItems;
}
