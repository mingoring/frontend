import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.iconPath,
    required this.iconSize,
    required this.onTap,
  });

  final String iconPath;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(iconSize / 2),
      onTap: onTap,
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(iconPath, fit: BoxFit.contain),
      ),
    );
  }
}
