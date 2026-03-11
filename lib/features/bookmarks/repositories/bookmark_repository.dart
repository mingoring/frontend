import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../constants/bookmark_constants.dart';
import '../dto/bookmark_list_response_dto.dart';
import '../dto/bookmark_stats_response_dto.dart';
import '../errors/bookmark_error_mapper.dart';
import '../models/bookmark_item_model.dart';
import '../models/bookmark_stats_model.dart';

abstract interface class BookmarkRepository {
  Future<BookmarkStatsModel> fetchStats();

  Future<BookmarkListModel> fetchList({
    required BookmarkSortType sort,
    String? keyword,
  });
}

class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<BookmarkStatsModel> fetchStats() async {
    return _request(
      request: () => _dio.get(ApiConstants.bookmarkStatsPath),
      onSuccess: (data) => BookmarkStatsModel(
        count: BookmarkStatsResponseDto.fromJson(data).count,
      ),
    );
  }

  @override
  Future<BookmarkListModel> fetchList({
    required BookmarkSortType sort,
    String? keyword,
  }) async {
    return _request(
      request: () => _dio.get(
        ApiConstants.bookmarkListPath,
        queryParameters: {
          'sort': sort.apiValue,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        },
      ),
      onSuccess: (data) => BookmarkListResponseDto.fromJson(data).toModel(),
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
        throw mapBookmarkError(statusCode, data);
      }
      throw mapBookmarkError(statusCode, null);
    } catch (e, st) {
      Error.throwWithStackTrace(const UnknownException(), st);
    }
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(ref.watch(dioClientProvider));
});
