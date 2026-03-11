import 'dart:io';

import 'package:flutter/foundation.dart';

// 서버 API 설정 상수
// TODO: 백엔드 구현 후 baseUrl 재지정 필요
// 임시 Base URL (개발 환경)
// - 웹 / iOS 시뮬레이터 / macOS : http://localhost:8000
// - Android 에뮬레이터            : http://10.0.2.2:8000  (에뮬레이터 내부에서 호스트 루프백)

abstract final class ApiConstants {
  ApiConstants._();

  static const String _devBaseUrlDefault = 'http://localhost:8000';
  static const String _devBaseUrlAndroid = 'http://10.0.2.2:8000';

  static String get baseUrl =>
      (!kIsWeb && Platform.isAndroid) ? _devBaseUrlAndroid : _devBaseUrlDefault;

  // ── Auth ──────────────────────────────────────────
  static const String signupPath = '/api/v1/auth/signup';

  // ── Credits / Referral ────────────────────────────
  static const String referralVerifyPath =
      '/api/v1/credits/rewards/referral/verify';

  // ── Calendar ──────────────────────────────────────
  static const String calendarPath = '/api/v1/calendar';

  // ── Bookmarks ─────────────────────────────────────
  static const String bookmarkStatsPath = '/api/v1/bookmarks/stats';
  static const String bookmarkListPath = '/api/v1/bookmarks';

  // ── Library ───────────────────────────────────────
  static const String lessonsPath = '/api/v1/lessons';
}
