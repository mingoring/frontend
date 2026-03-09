import 'package:flutter/material.dart';

import '../theme/app_logo_typography.dart';

abstract final class NicknameTypographyCache {
  static const int _maxCacheEntries = 200;
  static final Map<_NicknameStyleCacheKey, TextStyle> _cache = {};

  static const List<TextStyle> _fallbackOrder = [
    AppLogoTypography.logoEb2,
    AppLogoTypography.logoEb3,
    AppLogoTypography.logoEb4,
    AppLogoTypography.logoEb5,
  ];

  static TextStyle resolve({
    required BuildContext context,
    required String nickname,
    required double maxWidth,
  }) {
    final availableWidth = maxWidth.isFinite && maxWidth > 0 ? maxWidth : 0.0;
    final key = _NicknameStyleCacheKey(
      text: '$nickname!',
      widthBucket: availableWidth.round(),
    );

    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final resolved = _pickStyleThatFits(
      context: context,
      text: key.text,
      maxWidth: availableWidth,
    );

    if (_cache.length >= _maxCacheEntries) {
      _cache.clear();
    }
    _cache[key] = resolved;
    return resolved;
  }

  static TextStyle _pickStyleThatFits({
    required BuildContext context,
    required String text,
    required double maxWidth,
  }) {
    final textDirection = Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    for (final style in _fallbackOrder) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 1,
      )..layout(maxWidth: maxWidth);

      if (!painter.didExceedMaxLines) {
        return style;
      }
    }

    return AppLogoTypography.logoEb5;
  }
}

class _NicknameStyleCacheKey {
  const _NicknameStyleCacheKey({
    required this.text,
    required this.widthBucket,
  });

  final String text;
  final int widthBucket;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _NicknameStyleCacheKey &&
        other.text == text &&
        other.widthBucket == widthBucket;
  }

  @override
  int get hashCode => Object.hash(text, widthBucket);
}
