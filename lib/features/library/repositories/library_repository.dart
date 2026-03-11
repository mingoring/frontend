import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../dto/library_list_response_dto.dart';
import '../errors/library_error_mapper.dart';
import '../models/library_item_model.dart';
import '../widgets/library_filter_bar.dart';

extension _FilterOptionX on LibraryFilterOption {
  String get apiValue => switch (this) {
        LibraryFilterOption.all => 'ALL',
        LibraryFilterOption.uploading => 'UPLOADING',
        LibraryFilterOption.inProgress => 'IN_PROGRESS',
        LibraryFilterOption.completed => 'COMPLETED',
      };
}

abstract interface class LibraryRepository {
  Future<LessonListModel> fetchList({required LibraryFilterOption filter});
}

class LibraryRepositoryImpl implements LibraryRepository {
  const LibraryRepositoryImpl(this._dio);

  final Dio _dio;

  static const int _defaultPage = 1;
  static const int _defaultSize = 20;

  @override
  Future<LessonListModel> fetchList({
    required LibraryFilterOption filter,
  }) async {
    return _request(
      request: () => _dio.get(
        ApiConstants.lessonsPath,
        queryParameters: {
          'status': filter.apiValue,
          'page': _defaultPage,
          'size': _defaultSize,
        },
      ),
      onSuccess: (data) => LessonListResponseDto.fromJson(data).toModel(),
    );
  }

  Future<T> _request<T>({
    required Future<dynamic> Function() request,
    required T Function(Map<String, dynamic>) onSuccess,
  }) async {
    try {
      final response = await request();
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const UnknownException();
      }
      return onSuccess(data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
      }
      final statusCode = e.response?.statusCode ?? 0;
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw mapLibraryError(statusCode, data);
      }
      throw mapLibraryError(statusCode, null);
    } catch (e, st) {
      Error.throwWithStackTrace(const UnknownException(), st);
    }
  }
}

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl(ref.watch(dioClientProvider));
});
