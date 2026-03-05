import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/inputs/mingoring_switch_toggle.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isRegularOn = false;
  bool _isSmallOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Switch Toggle Test')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(
              label: 'Regular',
              value: _isRegularOn,
              onChanged: (v) => setState(() => _isRegularOn = v),
            ),
            const SizedBox(height: 24),
            _buildRow(
              label: 'Small',
              value: _isSmallOn,
              size: MingoringSwitchToggleSize.small,
              onChanged: (v) => setState(() => _isSmallOn = v),
            ),
            const SizedBox(height: 24),
            _buildRow(
              label: 'Disabled',
              value: false,
            ),
            const SizedBox(height: 24),
            _buildRow(
              label: 'Disabled S',
              value: true,
              size: MingoringSwitchToggleSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required bool value,
    MingoringSwitchToggleSize size = MingoringSwitchToggleSize.regular,
    ValueChanged<bool>? onChanged,
  }) {
    final isEnabled = onChanged != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        MingoringSwitchToggle(
          value: value,
          onChanged: onChanged,
          size: size,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            value ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isEnabled
                  ? (value ? AppColors.pink600 : AppColors.gray500)
                  : AppColors.gray400,
            ),
          ),
        ),
      ],
    );
  }
}
