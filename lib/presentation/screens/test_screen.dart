import 'package:flutter/material.dart';

import '../../core/widgets/buttons/mingoring_verify_button.dart';

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
      appBar: AppBar(title: const Text('MingoringVerifyButton Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Enabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringVerifyButton(
                onPressed: () => _showSnackBar('Verify Enabled'),
                child: const Text('Verify'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Disabled'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringVerifyButton(
                onPressed: null,
                child: const Text('Verify'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Style Override (width: 160)'),
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringVerifyButton(
                onPressed: () => _showSnackBar('Custom Width'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(160, 50),
                ),
                child: const Text('Verify'),
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
            Align(
              alignment: Alignment.centerLeft,
              child: MingoringVerifyButton(
                onPressed:
                    _isEnabled ? () => _showSnackBar('Dynamic Verify') : null,
                child: Text(_isEnabled ? 'Verify' : 'Verify'),
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
