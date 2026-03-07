import 'package:flutter/material.dart';

abstract final class AppLogoTypography {
  static const String _fontFamily = 'Paperlogy';

  // ──────────────────────────────────────────
  // Logo Level 1 — 40px
  // ──────────────────────────────────────────

  static const TextStyle logo1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 40,
    height: 1.03,
    letterSpacing: -0.4, // -1%
  );

  // ──────────────────────────────────────────
  // Logo Level 2 — 34px
  // ──────────────────────────────────────────

  static const TextStyle logoEb2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 34,
    height: 1.03,
    letterSpacing: 0, // 0%
  );

  static const TextStyle logoB2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 34,
    height: 1.03,
    letterSpacing: 0, // 0%
  );

  // ──────────────────────────────────────────
  // Logo Level 3 — 28px
  // ──────────────────────────────────────────

  static const TextStyle logoEb3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.03,
    letterSpacing: 0.28, // 1%
  );

  static const TextStyle logoB3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.03,
    letterSpacing: 0.28, // 1%
  );

  // ──────────────────────────────────────────
  // Logo Level 4 — 25px
  // ──────────────────────────────────────────

  static const TextStyle logoEb4 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 25,
    height: 1.03,
    letterSpacing: 0.25, // 1%
  );

  static const TextStyle logoB4 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 25,
    height: 1.03,
    letterSpacing: 0.25, // 1%
  );

  // ──────────────────────────────────────────
  // Logo Level 5 — 20px
  // ──────────────────────────────────────────

  static const TextStyle logoEb5 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.03,
    letterSpacing: 0.4, // 2%
  );

  static const TextStyle logoB5 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.03,
    letterSpacing: 0.4, // 2%
  );

  // ──────────────────────────────────────────
  // Logo Level 6 — 16px
  // ──────────────────────────────────────────

  static const TextStyle logo6 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.03,
    letterSpacing: 0, // 0%
  );
}
