import 'package:flutter/material.dart';

import '../../core/widgets/inputs/app_checkbox.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _bigChecked = false;
  bool _smallChecked = false;

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
              'AppCheckbox',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildRow('Enabled', [
              _buildItem(
                'Big',
                AppCheckbox(
                  isSelected: _bigChecked,
                  onChanged: (v) => setState(() => _bigChecked = v),
                ),
              ),
              _buildItem(
                'Small',
                AppCheckbox(
                  isSelected: _smallChecked,
                  size: AppCheckboxSize.small,
                  onChanged: (v) => setState(() => _smallChecked = v),
                ),
              ),
            ]),
            const SizedBox(height: 32),
            _buildRow('Disabled', [
              _buildItem(
                'Big Off',
                const AppCheckbox(isSelected: false),
              ),
              _buildItem(
                'Big On',
                const AppCheckbox(isSelected: true),
              ),
              _buildItem(
                'Small Off',
                const AppCheckbox(
                  isSelected: false,
                  size: AppCheckboxSize.small,
                ),
              ),
              _buildItem(
                'Small On',
                const AppCheckbox(
                  isSelected: true,
                  size: AppCheckboxSize.small,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, List<Widget> children) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ],
    );
  }

  Widget _buildItem(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          child,
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
