import 'package:flutter/material.dart';

import '../../core/widgets/buttons/mingoring_watch_button.dart';

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
      appBar: AppBar(title: const Text('MingoringWatchButton Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Big — Enabled'),
            MingoringWatchButton(
              onPressed: () => _showSnackBar('Big Enabled'),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Big — Disabled'),
            MingoringWatchButton(
              onPressed: null,
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Small — Enabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringWatchButton(
                size: MingoringWatchButtonSize.small,
                onPressed: () => _showSnackBar('Small Enabled'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Small — Disabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringWatchButton(
                size: MingoringWatchButtonSize.small,
                onPressed: null,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Style Override'),
            MingoringWatchButton(
              onPressed: () => _showSnackBar('Style Override'),
              style: TextButton.styleFrom(
                minimumSize: const Size(200, 50),
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
            _buildSectionLabel('Big — Dynamic'),
            MingoringWatchButton(
              onPressed:
                  _isEnabled ? () => _showSnackBar('Big Dynamic') : null,
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Small — Dynamic'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringWatchButton(
                size: MingoringWatchButtonSize.small,
                onPressed:
                    _isEnabled ? () => _showSnackBar('Small Dynamic') : null,
              ),
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
