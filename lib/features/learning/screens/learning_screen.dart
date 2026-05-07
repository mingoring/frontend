import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';

/// 학습 화면 — 영상별 웹뷰를 표시한다.
///
/// [videoUrl] 은 현재 하드코딩된 임시 URL을 사용한다.
/// TODO: LibraryScreen → LearningScreen 네비게이션 시 영상별 URL을 [videoUrl]로 전달하도록 변경
class LearningScreen extends StatefulWidget {
  const LearningScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  /// 웹뷰에 로드할 학습 URL
  final String videoUrl;

  /// 앱 바에 표시할 영상 제목
  final String title;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // iOS에서 YouTube 영상이 자동으로 전체화면이 되는 것을 방지
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MingoringAppBar(
        onBack: () => Navigator.of(context).pop(),
        type: MingoringBackHeaderType.title,
        text: widget.title,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
