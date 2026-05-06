import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/library_item_model.dart';
import '../models/video_watch_screen_args.dart';
import '../player/youtube_player_adapter.dart';
import '../player/youtube_player_flutter_adapter.dart';
import '../widgets/playing_bar.dart';
import '../widgets/playing_speed_popup.dart';

class VideoWatchScreen extends StatefulWidget {
  const VideoWatchScreen({super.key, required this.args});

  final VideoWatchScreenArgs args;

  @override
  State<VideoWatchScreen> createState() => _VideoWatchScreenState();
}

class _VideoWatchScreenState extends State<VideoWatchScreen> {
  late final YouTubePlayerAdapter _adapter;

  bool _isPlaying = false;
  bool _isAutoPlay = false;
  bool _showSpeedPopup = false;
  PlaybackSpeed _selectedSpeed = PlaybackSpeed.normal;
  bool _isBookmarked = false;
  bool _isPatternExpanded = true;

  LessonItemModel get _item => widget.args.item;

  @override
  void initState() {
    super.initState();
    // TODO: API가 videoId를 내려주면 item.videoId로 교체 (library_screen.dart 참고)
    // 구현체 교체 시 이 한 줄만 변경: YouTubePlayerFlutterAdapter → YouTubePlayerIframeAdapter
    _adapter = YouTubePlayerFlutterAdapter(videoId: widget.args.videoId);
    _adapter.state.addListener(_onPlayerStateChanged);
  }

  void _onPlayerStateChanged() {
    if (!mounted) return;
    final isPlaying = _adapter.state.value.isPlaying;
    if (_isPlaying != isPlaying) {
      setState(() => _isPlaying = isPlaying);
    }
  }

  @override
  void dispose() {
    _adapter.state.removeListener(_onPlayerStateChanged);
    _adapter.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_adapter.state.value.isPlaying) {
      _adapter.pause();
    } else {
      _adapter.play();
    }
  }

  void _toggleAutoPlay() => setState(() => _isAutoPlay = !_isAutoPlay);
  void _toggleSpeedPopup() =>
      setState(() => _showSpeedPopup = !_showSpeedPopup);
  void _toggleBookmark() => setState(() => _isBookmarked = !_isBookmarked);
  void _togglePattern() =>
      setState(() => _isPatternExpanded = !_isPatternExpanded);

  void _onSpeedSelected(PlaybackSpeed speed) {
    setState(() {
      _selectedSpeed = speed;
      _showSpeedPopup = false;
    });
    _adapter.setPlaybackRate(speed.value);
  }

  void _seekBack() {
    final pos = _adapter.state.value.position;
    _adapter.seekTo(pos - const Duration(seconds: 10));
  }

  void _seekForward() {
    final pos = _adapter.state.value.position;
    _adapter.seekTo(pos + const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return _adapter.buildPlayerScaffold(
      context: context,
      builder: (context, player) => Scaffold(
        backgroundColor: AppColors.pink50,
        body: Stack(
          children: [
            Column(
              children: [
                _Header(title: _item.title, onClose: context.pop),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        player,
                        _ScriptCounter(current: 1, total: 1),
                        const SizedBox(height: 5),
                        _ScriptCard(
                          originalText: _item.originalText,
                          translatedText: _item.translatedText,
                          isBookmarked: _isBookmarked,
                          isPatternExpanded: _isPatternExpanded,
                          onBookmarkTap: _toggleBookmark,
                          onPatternToggle: _togglePattern,
                        ),
                        const SizedBox(height: PlayingBar.height),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ─── Playing Bar (하단 고정) ───────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlayingBar(
                isPlaying: _isPlaying,
                selectedSpeed: _selectedSpeed,
                isAutoPlay: _isAutoPlay,
                onPlayPause: _togglePlay,
                onBack: _seekBack,
                onForward: _seekForward,
                onSpeedTap: _toggleSpeedPopup,
                onAutoPlayTap: _toggleAutoPlay,
              ),
            ),

            // ─── 속도 선택 팝업 ────────────────────────────────────────────
            if (_showSpeedPopup)
              Positioned(
                left: 10,
                bottom: PlayingBar.height,
                child: PlayingSpeedPopup(
                  selectedSpeed: _selectedSpeed,
                  onSpeedSelected: _onSpeedSelected,
                ),
              ),

            if (_showSpeedPopup)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => _showSpeedPopup = false),
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── 헤더 ─────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  static const double _contentHeight = 39;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _contentHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: SvgPicture.asset(
                    AppIconAssets.close,
                    width: 15,
                    height: 15,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray900,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 27),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.body7B14.copyWith(
                      color: AppColors.gray900,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 27),
                // TODO: 설정 화면 연동
                SvgPicture.asset(
                  AppIconAssets.setting,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray900,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 스크립트 카운터 ──────────────────────────────────────────────────────────

class _ScriptCounter extends StatelessWidget {
  const _ScriptCounter({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$current/$total',
          style: AppTextStyles.detail6Md12.copyWith(
            color: AppColors.gray500,
          ),
        ),
      ),
    );
  }
}

// ─── 스크립트 카드 ────────────────────────────────────────────────────────────

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({
    required this.originalText,
    required this.translatedText,
    required this.isBookmarked,
    required this.isPatternExpanded,
    required this.onBookmarkTap,
    required this.onPatternToggle,
  });

  final String originalText;
  final String translatedText;
  final bool isBookmarked;
  final bool isPatternExpanded;
  final VoidCallback onBookmarkTap;
  final VoidCallback onPatternToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.pink600),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: AppColors.gray300, blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScriptSection(
              originalText: originalText,
              translatedText: translatedText,
              isBookmarked: isBookmarked,
              onBookmarkTap: onBookmarkTap,
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.gray200, height: 1),
            const SizedBox(height: 14),
            // TODO: API에서 문법 설명 데이터 수신 시 교체
            _GrammarDescription(
              description:
                  'This conveys sincere gratitude and a shared journey made possible by support.',
            ),
            const SizedBox(height: 18),
            _GrammarPatternBox(
              isExpanded: isPatternExpanded,
              onToggle: onPatternToggle,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 스크립트 섹션 (원문 + 번역 + 북마크) ────────────────────────────────────

class _ScriptSection extends StatelessWidget {
  const _ScriptSection({
    required this.originalText,
    required this.translatedText,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  final String originalText;
  final String translatedText;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                originalText,
                style: AppTextStyles.body7B14.copyWith(
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                translatedText,
                style: AppTextStyles.body8Sb14.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onBookmarkTap,
          child: SvgPicture.asset(
            isBookmarked
                ? AppIconAssets.btnBookmarkPink
                : AppIconAssets.btnBookmarkGray,
            width: 20,
            height: 22,
          ),
        ),
      ],
    );
  }
}

// ─── 문법 설명 ────────────────────────────────────────────────────────────────

class _GrammarDescription extends StatelessWidget {
  const _GrammarDescription({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: AppTextStyles.detail6Md12.copyWith(color: AppColors.gray600),
    );
  }
}

// ─── 문법 패턴 박스 ───────────────────────────────────────────────────────────

class _GrammarPatternBox extends StatelessWidget {
  const _GrammarPatternBox({
    required this.isExpanded,
    required this.onToggle,
  });

  // TODO: API에서 패턴/예문 데이터 수신 시 파라미터로 분리
  static const String _patternFormula = '[someone] 덕분에 [result/feelings].';
  static const String _patternDescription =
      'You can use this pattern to express that something positive happened because of someone.';
  static const List<_ExamplePair> _examples = [
    _ExamplePair('[너] 덕분에 [성공했어].', '[I succeeded] because of [you].'),
    _ExamplePair('[그녀] 덕분에 [즐거웠어].', '[I had fun] because of [her].'),
    _ExamplePair('[BTS] 덕분에 [힘이 나].', '[I feel energized] because of [BTS].'),
  ];

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pink100,
        border: Border.all(color: AppColors.pink300),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _PatternFormulaText(formula: _patternFormula),
              ),
              GestureDetector(
                onTap: onToggle,
                child: SvgPicture.asset(
                  isExpanded
                      ? AppIconAssets.arrowUpMiniPink
                      : AppIconAssets.arrowDownMiniPink,
                  width: 17,
                  height: 17,
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 8),
            Text(
              _patternDescription,
              style: AppTextStyles.detail6Md12.copyWith(
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 10),
            ..._examples.map(
              (ex) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ExampleItem(pair: ex),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── 패턴 공식 텍스트 (pink highlight 포함) ───────────────────────────────────

class _PatternFormulaText extends StatelessWidget {
  const _PatternFormulaText({required this.formula});

  final String formula;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\[.*?\]|[^\[]+');
    for (final match in regex.allMatches(formula)) {
      final text = match.group(0)!;
      final isBracket = text.startsWith('[');
      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(
            color: isBracket ? AppColors.pink600 : AppColors.black,
          ),
        ),
      );
    }
    return RichText(
      text: TextSpan(
        style: AppTextStyles.detail5Sb12,
        children: spans,
      ),
    );
  }
}

// ─── 예문 아이템 ──────────────────────────────────────────────────────────────

class _ExampleItem extends StatelessWidget {
  const _ExampleItem({required this.pair});

  final _ExamplePair pair;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PatternFormulaText(formula: pair.korean),
        Text(
          pair.english,
          style: AppTextStyles.detail6Md12.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }
}

class _ExamplePair {
  const _ExamplePair(this.korean, this.english);

  final String korean;
  final String english;
}
