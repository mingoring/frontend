import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_icon_assets.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  static const double _iconSize = 12.0;

  bool _isEyeOn = true;
  bool _isDocumentOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Widget Preview')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AppEyeVisibilityIcon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildToggleItem(
              isOn: _isEyeOn,
              onAsset: AppIconAssets.eyeOn,
              offAsset: AppIconAssets.eyeOff,
              onTap: () => setState(() => _isEyeOn = !_isEyeOn),
            ),
            const SizedBox(height: 60),
            const Text(
              'AppDocumentVisibilityIcon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildToggleItem(
              isOn: _isDocumentOn,
              onAsset: AppIconAssets.documentOn,
              offAsset: AppIconAssets.documentOff,
              onTap: () => setState(() => _isDocumentOn = !_isDocumentOn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required bool isOn,
    required String onAsset,
    required String offAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            isOn ? onAsset : offAsset,
            width: _iconSize,
            height: _iconSize,
          ),
          const SizedBox(height: 6),
          Text(
            isOn ? 'On' : 'Off',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
