import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../dto/calendar_response_dto.dart';
import '../errors/calendar_error_mapper.dart';
import '../models/calendar_data_model.dart';

abstract interface class CalendarRepository {
  Future<CalendarDataModel> fetchRecent({
    required String accessToken,
    required String timezone,
    required DateTime todayDate,
  });

  Future<CalendarDataModel> fetchMonthly({
    required String accessToken,
    required String timezone,
    required DateTime todayDate,
    required DateTime targetMonth,
  });
}

class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<CalendarDataModel> fetchRecent({
    required String accessToken,
    required String timezone,
    required DateTime todayDate,
  }) async {
    return _fetchCalendar(
      accessToken: accessToken,
      timezone: timezone,
      todayDate: todayDate,
      viewType: CalendarViewType.recent,
    );
  }

  @override
  Future<CalendarDataModel> fetchMonthly({
    required String accessToken,
    required String timezone,
    required DateTime todayDate,
    required DateTime targetMonth,
  }) async {
    return _fetchCalendar(
      accessToken: accessToken,
      timezone: timezone,
      todayDate: todayDate,
      viewType: CalendarViewType.monthly,
      targetMonth: targetMonth,
    );
  }

  Future<CalendarDataModel> _fetchCalendar({
    required String accessToken,
    required String timezone,
    required DateTime todayDate,
    required CalendarViewType viewType,
    DateTime? targetMonth,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.calendarPath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        queryParameters: {
          'timezone': timezone,
          'todayDate': _formatDate(todayDate),
          'viewType': viewType.toApiValue(),
          if (viewType == CalendarViewType.monthly && targetMonth != null)
            'targetMonth': _formatMonth(targetMonth),
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const UnknownException();
      }

      return CalendarResponseDto.fromJson(data).toModel();
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
        throw mapCalendarError(statusCode, data);
      }

      throw mapCalendarError(statusCode, null);
    } catch (e, st) {
      Error.throwWithStackTrace(const UnknownException(), st);
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatMonth(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl(ref.watch(dioClientProvider));
});
