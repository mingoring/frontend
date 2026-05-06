원본: https://pub.dev/packages/youtube_player_flutter

# youtube_player_flutter

Flutter 앱에서 YouTube 영상을 **인라인으로 재생**하기 위한 패키지입니다. 공식 **YouTube iFrame Player API**를 기반으로 하며, **API Key 없이** 재생 기능을 붙일 수 있습니다. 공식 설명에는 Android/iOS 지원이 핵심으로 안내되어 있고, 웹은 `youtube_player_iframe` 사용이 권장됩니다.

## 핵심 특징

* 인라인 재생 지원
* 자막 지원
* API Key 불필요
* 커스텀 컨트롤 지원
* 영상 메타데이터 조회 지원
* 라이브 스트림 지원
* 재생 속도 변경 지원
* Android/iOS 지원
* 네트워크 대역폭에 따른 품질 적응
* 가로 드래그 기반 탐색
* 핀치 제스처로 와이드 화면 대응 

## 언제 적합한가

다음과 같은 경우에 적합합니다.

* 앱 내부에서 YouTube 영상을 바로 재생하고 싶을 때
* 학습, 콘텐츠 소비, 미디어 피드형 화면에서 이탈 없는 재생 UX가 중요할 때
* 별도의 YouTube Data API 연동 없이 플레이어 기능이 필요할 때
* 기본 UI 외에 재생 컨트롤을 커스터마이징해야 할 때

## 요구 사항

### Android

* `minSdkVersion 17` 이상
* AndroidX 지원 필요
* 다만 공식 문서상 실제 재생은 **API 20 이상**이 필요하며, **Hybrid Composition 사용 시 API 19**까지 제한적으로 가능하다고 안내됩니다. 저버전 기기에서는 외부 YouTube 앱 또는 브라우저로 넘기는 대응이 권장됩니다. 

### iOS

* Swift 기반 프로젝트
* Xcode 11 이상
* 별도 추가 설정 없음 

## 설치

```yaml
dependencies:
  youtube_player_flutter: ^9.1.3
```

## 기본 사용법

### 1) 컨트롤러 초기화

`YoutubePlayerController`가 상태와 제어의 중심입니다. 보통 `StatefulWidget`의 `initState`에서 초기화하고, `dispose`에서 정리합니다.

```dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({super.key});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {
        debugPrint('Player is ready.');
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 2) 전체 화면 지원

전체 화면 전환이 필요하면 `YoutubePlayerBuilder`로 감싸는 방식이 공식 문서에 안내되어 있습니다. 

```dart
YoutubePlayerBuilder(
  player: YoutubePlayer(
    controller: _controller,
  ),
  builder: (context, player) {
    return Column(
      children: [
        player,
        const SizedBox(height: 16),
        const Text('비디오 상세 정보'),
      ],
    );
  },
)
```

## 주요 구성 요소

### `YoutubePlayerController`

플레이어 상태를 관리하고 재생, 일시정지, 탐색 등의 명령을 수행하는 핵심 객체입니다. 공식 Quick Links에도 주요 타입으로 노출됩니다. 

### `YoutubePlayerFlags`

초기 동작을 설정합니다.

예시:

* `autoPlay`
* `mute`
* `isLive`
* `useHybridComposition` 

### `YoutubePlayer`

실제 화면에 렌더링되는 위젯입니다. 진행 바, 액션 버튼, 라이브 UI 색상 등 UI 설정을 붙일 수 있습니다. 

## 고급 기능

### 라이브 스트림 재생

라이브 영상이면 `isLive: true`를 설정합니다. 라이브 전용 UI에 맞춰 표시되며, `liveUIColor`로 색상을 지정할 수 있습니다. 

```dart
_controller = YoutubePlayerController(
  initialVideoId: 'iLnmTe5Q2Qw',
  flags: const YoutubePlayerFlags(
    isLive: true,
  ),
);

YoutubePlayer(
  controller: _controller,
  liveUIColor: Colors.red,
)
```

### 커스텀 컨트롤

`topActions`, `bottomActions`를 통해 플레이어 UI를 커스터마이징할 수 있습니다. 공식 문서 예시에는 `CurrentPosition`, `ProgressBar`, `TotalDuration` 등이 소개되어 있습니다. 

```dart
YoutubePlayer(
  controller: _controller,
  bottomActions: const [
    CurrentPosition(),
    ProgressBar(isExpanded: true),
    TotalDuration(),
  ],
)
```

## URL 처리 유틸리티

YouTube URL에서 videoId를 추출할 수 있습니다. 공식 제공 유틸리티는 다음과 같습니다. 

```dart
final videoId = YoutubePlayer.convertUrlToId(
  'https://www.youtube.com/watch?v=BBAyRBTfsOU',
);

print(videoId); // BBAyRBTfsOU
```

## 자주 쓰는 API 개념

공식 Quick Links에는 다음 타입들이 문서화되어 있습니다. 

* `YoutubePlayer`
* `YoutubePlayerController`
* `YoutubePlayerFlags`
* `YoutubePlayerValue`
* `YoutubeMetaData`

실무에서 특히 자주 보게 되는 값은 다음과 같습니다.

### `YoutubeMetaData`

* `videoId`
* `title`
* `author`
* `duration`

### `YoutubePlayerValue`

* `isPlaying`
* `isReady`
* `position`
* `buffered`
* `playerState`
* `volume`

### 컨트롤러 메서드 예시

* `load(...)`
* `cue(...)`
* `seekTo(...)`
* `setVolume(...)`
* `setPlaybackRate(...)`

## 주의 사항

### Platform Views 기반

이 패키지는 내부적으로 `flutter_inappwebview`를 사용하며, Flutter의 플랫폼 뷰 임베딩 메커니즘에 의존합니다. 따라서 일부 이슈는 platform views 계열 이슈와 유사하게 나타날 수 있습니다. 

### Android 저버전 대응

공식 문서상 `minSdkVersion`은 17이지만, 실제 플레이어 재생은 API 20 이상이 필요합니다. API 19는 Hybrid Composition에서만 제한적으로 가능하므로, 저버전 단말은 `url_launcher`나 Android Intent를 사용해 외부 앱 재생으로 우회하는 전략이 현실적입니다. 

### 리스트 내 다중 플레이어

공식 문서가 직접 리스트 최적화 패턴을 길게 설명하진 않지만, 플랫폼 뷰 기반 특성상 플레이어를 여러 개 동시에 띄우는 구조는 비용이 큽니다. 실무에서는 다음처럼 운영하는 편이 안전합니다.

* 화면에 보이는 아이템만 활성화
* 스크롤 아웃된 플레이어는 pause
* 필요 없으면 dispose
* 피드형 화면이라면 썸네일 + 단일 활성 플레이어 구조 우선 검토

## 한 줄 요약

`youtube_player_flutter`는 Flutter 앱에서 YouTube를 인라인으로 재생하기 위한 대표 패키지이며, **API Key 없이 빠르게 붙일 수 있고**, **전체 화면·라이브·커스텀 컨트롤**까지 지원합니다. 다만 **Platform Views 기반 제약**과 **Android 저버전 단말 대응**은 반드시 고려해야 합니다.

[1]: https://pub.dev/packages/youtube_player_flutter "youtube_player_flutter | Flutter package"
