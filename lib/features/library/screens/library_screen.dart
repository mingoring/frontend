import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/dialogs/video_uploading_alert_dialog.dart';
import '../../../core/widgets/dialogs/video_watch_alert_dialog.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library (Dialog Test)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => ErrorAlertDialog.show(
                    context,
                    errorMessage: 'Test error message.',
                  ),
                  child: const Text('Show ErrorAlertDialog'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => VideoWatchAlertDialog.show(
                    context,
                    videoTitle: '[ENG/JP] Sample video title',
                    learningTextKo: '여기 칼국수 맛집이라 해서 왔어요.',
                    learningTextEn:
                        'I came here because I heard this place is a good noodle restaurant.',
                  ),
                  child: const Text('Show VideoWatchAlertDialog'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => VideoUploadingAlertDialog.show(context),
                  child: const Text('Show VideoUploadingAlertDialog'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
