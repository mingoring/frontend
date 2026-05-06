import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 학습 화면 — 영상별 웹뷰를 전체 화면으로 표시한다.
///
/// [videoUrl] 은 현재 하드코딩된 임시 URL을 사용한다.
/// TODO: LibraryScreen → LearningScreen 네비게이션 시 영상별 URL을 [videoUrl]로 전달하도록 변경
class LearningScreen extends StatefulWidget {
  const LearningScreen({
    super.key,
    required this.videoUrl,
  });

  /// 웹뷰에 로드할 학습 URL
  final String videoUrl;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
