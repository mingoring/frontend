import '../models/library_item_model.dart';
import '../widgets/library_filter_bar.dart';

/// LibraryScreen -> LibraryEditScreen 이동 시 전달하는 편집용 스냅샷
///
/// - [initialItems]: 편집 화면의 원본 기준이 되는 전체 아이템 목록
/// - [initialFilter]: 편집 화면 진입 시 처음 선택할 필터
class LibraryEditScreenArgs {
  const LibraryEditScreenArgs({
    required this.initialItems,
    required this.initialFilter,
  });

  final List<LessonItemModel> initialItems;
  final LibraryFilterOption initialFilter;
}
