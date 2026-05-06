--name: youtube-player
--description: YouTube 플레이어 통합 가이드. Adapter 패턴 구조, 패키지 교체 방법, 컨트롤러 생명주기, 컨트롤 연동, videoId 데이터 흐름을 다룹니다.
--

# YouTube Player 통합 가이드

## 1. 패키지

```yaml
# pubspec.yaml
dependencies:
  youtube_player_flutter: ^9.1.3
```

- 공식 YouTube iFrame Player API 기반 (API Key 불필요)
- Android / iOS 지원, 내부적으로 Platform Views 사용
- 마이너 업그레이드(`^`) 허용. 메이저 변경 시 어댑터 구현체만 수정하면 됩니다.

---

## 2. 아키텍처: Adapter 패턴

화면(`VideoWatchScreen`)은 추상 인터페이스(`YouTubePlayerAdapter`)에만 의존합니다.
패키지를 교체할 때 화면 코드는 **`initState` 한 줄**만 바꾸면 됩니다.

```
VideoWatchScreen
  └─ YouTubePlayerAdapter          (추상 인터페이스)
       ├─ YouTubePlayerFlutterAdapter   ← 현재 사용 중 (youtube_player_flutter)
       └─ YouTubePlayerIframeAdapter    ← 교체 시 새로 추가 (youtube_player_iframe)
```

### 파일 위치

```
lib/features/library/player/
├── youtube_player_adapter.dart           # 추상 인터페이스 + YouTubePlayerState
└── youtube_player_flutter_adapter.dart   # youtube_player_flutter 구현체
```

---

## 3. 추상 인터페이스 (`YouTubePlayerAdapter`)

```dart
abstract class YouTubePlayerAdapter {
  /// 플레이어 상태 변화를 구독할 수 있는 Listenable
  ValueListenable<YouTubePlayerState> get state;

  void play();
  void pause();
  void seekTo(Duration position);
  void setPlaybackRate(double rate);
  void dispose();

  /// 플레이어 위젯을 포함한 위젯 트리를 빌드.
  /// builder는 player 위젯을 받아 화면 레이아웃을 구성합니다.
  Widget buildPlayerScaffold({
    required BuildContext context,
    required Widget Function(BuildContext context, Widget player) builder,
  });
}

class YouTubePlayerState {
  const YouTubePlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.isReady = false,
  });

  final bool isPlaying;
  final Duration position;
  final bool isReady;
}
```

---

## 4. 현재 구현체 (`YouTubePlayerFlutterAdapter`)

패키지 전용 타입(`YoutubePlayerController`, `YoutubePlayerBuilder` 등)은
이 파일 안에만 존재합니다. 화면은 전혀 모릅니다.

```dart
class YouTubePlayerFlutterAdapter implements YouTubePlayerAdapter {
  YouTubePlayerFlutterAdapter({required String videoId}) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        useHybridComposition: true,
      ),
    )..addListener(_syncState);
  }

  late final YoutubePlayerController _controller;
  final _stateNotifier = ValueNotifier(const YouTubePlayerState());

  @override
  ValueListenable<YouTubePlayerState> get state => _stateNotifier;

  void _syncState() {
    _stateNotifier.value = YouTubePlayerState(
      isPlaying: _controller.value.isPlaying,
      position: _controller.value.position,
      isReady: _controller.value.isReady,
    );
  }

  @override void play() => _controller.play();
  @override void pause() => _controller.pause();
  @override void seekTo(Duration position) => _controller.seekTo(position);
  @override void setPlaybackRate(double rate) => _controller.setPlaybackRate(rate);

  @override
  void dispose() {
    _controller
      ..removeListener(_syncState)
      ..dispose();
    _stateNotifier.dispose();
  }

  @override
  Widget buildPlayerScaffold({
    required BuildContext context,
    required Widget Function(BuildContext context, Widget player) builder,
  }) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.pink600,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.pink600,
          handleColor: AppColors.pink400,
        ),
      ),
      builder: builder,  // 화면의 builder를 그대로 전달
    );
  }
}
```

---

## 5. 화면에서 어댑터 사용 패턴 (`VideoWatchScreen`)

### initState / dispose

```dart
late final YouTubePlayerAdapter _adapter;

@override
void initState() {
  super.initState();
  // 패키지 교체 시 이 한 줄만 변경
  _adapter = YouTubePlayerFlutterAdapter(videoId: widget.args.videoId);
  _adapter.state.addListener(_onPlayerStateChanged);
}

void _onPlayerStateChanged() {
  if (!mounted) return;
  final isPlaying = _adapter.state.value.isPlaying;
  if (_isPlaying != isPlaying) setState(() => _isPlaying = isPlaying);
}

@override
void dispose() {
  _adapter.state.removeListener(_onPlayerStateChanged);
  _adapter.dispose();
  super.dispose();
}
```

### 재생 컨트롤

```dart
// 재생/일시정지 — 상태는 어댑터에서 읽음
void _togglePlay() {
  if (_adapter.state.value.isPlaying) {
    _adapter.pause();
  } else {
    _adapter.play();
  }
}

// ±10초 탐색
void _seekBack()    => _adapter.seekTo(_adapter.state.value.position - const Duration(seconds: 10));
void _seekForward() => _adapter.seekTo(_adapter.state.value.position + const Duration(seconds: 10));

// 배속 변경 (PlaybackSpeed.value는 double)
void _onSpeedSelected(PlaybackSpeed speed) {
  setState(() { _selectedSpeed = speed; _showSpeedPopup = false; });
  _adapter.setPlaybackRate(speed.value);
}
```

### build 메서드

```dart
@override
Widget build(BuildContext context) {
  return _adapter.buildPlayerScaffold(
    context: context,
    builder: (context, player) => Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // 헤더
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      player,  // ← 어댑터가 전달한 플레이어 위젯
                      // 스크립트 카드 등
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned: PlayingBar, 팝업 등
        ],
      ),
    ),
  );
}
```

> `buildPlayerScaffold`가 내부에서 `YoutubePlayerBuilder`를 처리하므로
> 화면은 패키지별 래퍼를 알 필요가 없습니다.

---

## 6. videoId 데이터 흐름

```
LessonItemDto (API 응답)
  └─ toModel() → LessonItemModel.videoId: String?
       └─ LibraryScreen 에서 VideoWatchScreenArgs(videoId: item.videoId ?? 'nM0xDI5R50E')
            └─ VideoWatchScreen → _adapter = YouTubePlayerFlutterAdapter(videoId: widget.args.videoId)
```

### API 대응 완료 시 변경 위치 (한 곳)

**`library_screen.dart`** — TODO 주석 위치:

```dart
// 변경 전 (현재, 임시 고정값 사용)
videoId: item.videoId ?? 'nM0xDI5R50E',

// 변경 후 (API가 videoId를 내려줄 때)
videoId: item.videoId ?? '',
```

DTO → Model 매핑(`LessonItemDto.toModel`)은 이미 연결되어 있어 별도 수정 불필요.

---

## 7. 패키지를 `youtube_player_iframe`으로 교체하는 방법

> **교체 시 실제로 해야 할 일 (3가지)**
>
> 1. `pubspec.yaml` 패키지 교체
> 2. `YouTubePlayerIframeAdapter` 파일 하나 작성 (`YouTubePlayerAdapter` 구현)
> 3. `VideoWatchScreen.initState` 생성자 한 줄 변경
>
> 화면 코드, 컨트롤 로직, 위젯 구조는 변경 없음.

### Step 1 — pubspec.yaml

```yaml
# 제거
youtube_player_flutter: ^9.1.3

# 추가
youtube_player_iframe: ^5.x.x
```

### Step 2 — 새 어댑터 파일 작성

`lib/features/library/player/youtube_player_iframe_adapter.dart` 를 새로 만들고
`YouTubePlayerAdapter`를 구현합니다.

```dart
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'youtube_player_adapter.dart';

class YouTubePlayerIframeAdapter implements YouTubePlayerAdapter {
  YouTubePlayerIframeAdapter({required String videoId}) {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    // state 동기화 로직 구현
  }

  late final YoutubePlayerController _controller;
  // ... 나머지 구현
}
```

### Step 3 — `VideoWatchScreen.initState` 한 줄 변경

```dart
// 변경 전
_adapter = YouTubePlayerFlutterAdapter(videoId: widget.args.videoId);

// 변경 후
_adapter = YouTubePlayerIframeAdapter(videoId: widget.args.videoId);
```

화면 코드, `buildPlayerScaffold` 호출, 컨트롤 메서드는 **변경 없음**.

---

## 8. 유지보수 체크리스트

### 패키지 업그레이드 시
- [ ] 어댑터 구현체(`youtube_player_flutter_adapter.dart`)만 수정
- [ ] `YouTubePlayerAdapter` 인터페이스는 변경하지 않음
- [ ] `VideoWatchScreen`은 건드리지 않음

### 새 화면에서 플레이어 추가 시
1. 화면 args에 `videoId: String` 포함
2. `StatefulWidget` — initState에서 어댑터 생성, dispose에서 정리
3. `_adapter.state.addListener` / `removeListener` 쌍 유지
4. build는 `_adapter.buildPlayerScaffold(builder: ...)` 호출

### 새 컨트롤 기능 추가 시
1. `YouTubePlayerAdapter`에 추상 메서드 선언
2. 모든 구현체에 구현 (현재는 `YouTubePlayerFlutterAdapter` 하나)
3. 화면에서 해당 메서드 호출

---

## 9. 알려진 제약사항

| 항목 | 내용 |
|---|---|
| Android minSdkVersion | 실제 재생은 API 20 이상 필요. API 17~19는 Hybrid Composition에서만 제한적 지원 |
| 다중 플레이어 | Platform Views 특성상 동시 여러 인스턴스는 비용이 큼. 화면당 1개 유지 |
| 웹 플랫폼 | 웹은 `youtube_player_iframe` 권장. 이 프로젝트는 모바일 전용이므로 해당 없음 |
| buildPlayerScaffold | 구현체 내부에서 `YoutubePlayerBuilder` 처리. 화면이 직접 래퍼를 쓰면 안 됨 |
