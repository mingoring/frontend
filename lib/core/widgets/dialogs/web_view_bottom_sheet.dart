import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_icon_assets.dart';

/// URL을 인앱 바텀시트로 여는 웹뷰
class WebViewBottomSheet extends StatefulWidget {
  const WebViewBottomSheet({super.key, required this.url});

  final String url;

  static const double _sheetHeightFactor = 0.9;
  static const double _borderRadius = 20.0;
  static const double _topPadding = 12.0;
  static const double _closeIconSize = 24.0;
  static const double _closeIconPadding = 16.0;

  static Future<void> show(BuildContext context, {required String url}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: _sheetHeightFactor,
        child: WebViewBottomSheet(url: url),
      ),
    );
  }

  @override
  State<WebViewBottomSheet> createState() => _WebViewBottomSheetState();
}

class _WebViewBottomSheetState extends State<WebViewBottomSheet> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(
                top: WebViewBottomSheet._topPadding,
                right: WebViewBottomSheet._closeIconPadding,
              ),
              child: SizedBox(
                width: WebViewBottomSheet._closeIconSize,
                height: WebViewBottomSheet._closeIconSize,
                child: SvgPicture.asset(AppIconAssets.close),
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}
