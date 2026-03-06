import 'package:flutter/material.dart';

import '../../core/widgets/badges/mingoring_badge.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('MingoringBadge Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Small — Status'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.gray,
                  label: Text('All'),
                ),
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Uploading'),
                ),
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.darkPink,
                  label: Text('In Progress'),
                ),
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Completed'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Small — Inquiry'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.gray,
                  label: Text('Submitted'),
                ),
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.darkPink,
                  label: Text('Answered'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Small — Learning'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MingoringBadge(
                  badgeColor: MingoringBadgeColor.darkPink,
                  label: Text('Pattern'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionLabel('Big — Interest'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('K-pop'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('K-Drama & Movies'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Daily Life'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Travel'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Business'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Beauty & Fashion'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('K-Food'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Gaming'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Webtoon'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.pink,
                  label: Text('Trends & Slang'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Big — Level'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Lv 1 · Beginner'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Lv 2 · Elementary'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Lv 3 · Intermediate'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Lv 4 · Upper-Intermediate'),
                ),
                MingoringBadge(
                  size: MingoringBadgeSize.big,
                  badgeColor: MingoringBadgeColor.lightPink,
                  label: Text('Lv 5 · Advanced'),
                ),
              ],
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
}
