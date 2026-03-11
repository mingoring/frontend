import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/library_item_model.dart';

part 'library_list_response_dto.freezed.dart';
part 'library_list_response_dto.g.dart';

@freezed
class LessonItemDto with _$LessonItemDto {
  const factory LessonItemDto({
    required int lessonId,
    required String status,
    required String title,
    String? thumbnailUrl,
    required double progressRatio,
    required String videoTime,
    required String addedAt,
    required String originalText,
    required String translatedText,
  }) = _LessonItemDto;

  factory LessonItemDto.fromJson(Map<String, dynamic> json) =>
      _$LessonItemDtoFromJson(json);
}

@freezed
class PagingDto with _$PagingDto {
  const factory PagingDto({
    required int page,
    required int size,
    required int totalItems,
    required int totalPages,
    required bool hasNext,
  }) = _PagingDto;

  factory PagingDto.fromJson(Map<String, dynamic> json) =>
      _$PagingDtoFromJson(json);
}

@freezed
class LessonListResponseDto with _$LessonListResponseDto {
  const factory LessonListResponseDto({
    required List<LessonItemDto> items,
    required PagingDto paging,
  }) = _LessonListResponseDto;

  factory LessonListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LessonListResponseDtoFromJson(json);
}

extension LessonItemDtoX on LessonItemDto {
  LessonItemModel toModel() => LessonItemModel(
        lessonId: lessonId,
        status: LessonStatus.fromApiValue(status),
        title: title,
        thumbnailUrl: thumbnailUrl,
        progressRatio: progressRatio,
        videoTime: videoTime,
        addedAt: DateTime.parse(addedAt),
        originalText: originalText,
        translatedText: translatedText,
      );
}

extension LessonListResponseDtoX on LessonListResponseDto {
  LessonListModel toModel() => LessonListModel(
        items: items.map((e) => e.toModel()).toList(),
        hasNext: paging.hasNext,
        totalItems: paging.totalItems,
      );
}
