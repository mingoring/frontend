import 'package:flutter/material.dart';

import '../../core/widgets/buttons/mingoring_text_button.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('MingoringTextButton Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Big - Enabled'),
            MingoringTextButton(
              onPressed: () => _showSnackBar('Big Enabled'),
              child: const Text('Next'),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Big - Disabled'),
            MingoringTextButton(
              onPressed: null,
              child: const Text('Next'),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Small - Enabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 163,
                child: MingoringTextButton(
                  onPressed: () => _showSnackBar('Small Enabled'),
                  size: MingoringTextButtonSize.small,
                  child: const Text('Next'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Small - Disabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 163,
                child: MingoringTextButton(
                  onPressed: null,
                  size: MingoringTextButtonSize.small,
                  child: const Text('Next'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Popup - Enabled'),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 305,
                child: MingoringTextButton(
                  onPressed: () => _showSnackBar('Popup Enabled'),
                  size: MingoringTextButtonSize.popup,
                  child: const Text('Close'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Popup - Disabled'),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 305,
                child: MingoringTextButton(
                  onPressed: null,
                  size: MingoringTextButtonSize.popup,
                  child: const Text('Close'),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Enable / Disable 토글'),
                const Spacer(),
                Switch(
                  value: _isEnabled,
                  onChanged: (v) => setState(() => _isEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MingoringTextButton(
              onPressed: _isEnabled ? () => _showSnackBar('Dynamic') : null,
              child: Text(_isEnabled ? '활성화됨' : '비활성화됨'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$message 클릭됨')));
  }
}
