---
name: webview-ios-inline-playback
description: iOS WKWebView에서 YouTube 영상이 자동으로 전체화면이 되는 문제 해결 명세. LearningScreen WebView 설정 방법과 주의사항을 정의한다. WebView 관련 설정 수정 시 반드시 참고.
metadata:
  author: joy
  version: "1.0.0"
---

# iOS WebView 인라인 재생 설정

## 문제

iOS WKWebView의 기본값은 `allowsInlineMediaPlayback = false`다.
이 상태에서 YouTube IFrame 영상을 재생하면 Safari/WebKit이 자동으로 전체화면으로 전환한다.
웹 코드(React)에서 `playsinline` 속성을 추가해도 **Flutter 쪽 WebView 설정이 없으면 효과가 없다.**

---

## 현재 구현 (`lib/features/learning/screens/learning_screen.dart`)

```dart
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

final PlatformWebViewControllerCreationParams params =
    WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();

_controller = WebViewController.fromPlatformCreationParams(params)
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse(widget.videoUrl));
```

### 각 설정의 역할

| 설정 | 값 | 역할 |
|------|----|------|
| `allowsInlineMediaPlayback` | `true` | 영상을 앱 내 인라인으로 재생, 자동 전체화면 방지 |
| `mediaTypesRequiringUserAction` | `{}` (빈 셋) | 미디어 자동 재생에 별도 사용자 탭 불필요 |

---

## 주의사항

### 1. `WebViewController()` 직접 생성 금지
```dart
// 잘못된 방법 — iOS에서 전체화면 강제됨
_controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted);

// 올바른 방법 — 항상 fromPlatformCreationParams 사용
_controller = WebViewController.fromPlatformCreationParams(params);
```

### 2. 플랫폼 분기 유지
`WebKitWebViewPlatform` 체크를 반드시 유지한다.
Android는 `WebKitWebViewControllerCreationParams`를 지원하지 않아 런타임 에러가 발생한다.

### 3. 웹 코드와 세트로 동작
Flutter 설정만으로는 부족하다. 웹(React) 측 `YouTubePlayer.tsx`에서도 아래가 모두 적용되어야 한다:
- `playerVars: { playsinline: 1, fs: 0 }` — IFrame 내부 video에 playsinline 적용 + 전체화면 버튼 제거
- `onReady`에서 `getIframe()`으로 iframe 요소에 직접 `webkit-playsinline`, `playsinline`, `allow` 속성 주입

Flutter 설정과 웹 설정 **양쪽이 모두 있어야** iOS에서 인라인 재생이 보장된다.

---

## 패키지 의존성

`webview_flutter_wkwebview`는 `webview_flutter`의 iOS 구현체로 별도 추가 없이 자동 포함된다.
단, import는 명시적으로 선언해야 한다:

```dart
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
```
