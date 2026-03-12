import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class MingoringNavigationBar extends StatelessWidget {
  const MingoringNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  static const double _minHeight = 48.0;
  static const double _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: AppColors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final color = states.contains(WidgetState.selected)
                  ? AppColors.pink600
                  : AppColors.gray500;
              return AppTextStyles.detail7Md10.copyWith(color: color);
            }),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                AppIconAssets.libraryGray,
                width: _iconSize,
                height: _iconSize,
              ),
              selectedIcon: SvgPicture.asset(
                AppIconAssets.libraryPink,
                width: _iconSize,
                height: _iconSize,
              ),
              label: 'Library',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                AppIconAssets.homeGray,
                width: _iconSize,
                height: _iconSize,
              ),
              selectedIcon: SvgPicture.asset(
                AppIconAssets.homePink,
                width: _iconSize,
                height: _iconSize,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                AppIconAssets.userGray,
                width: _iconSize,
                height: _iconSize,
              ),
              selectedIcon: SvgPicture.asset(
                AppIconAssets.userPink,
                width: _iconSize,
                height: _iconSize,
              ),
              label: 'My page',
            ),
          ],
        ),
      ),
    );
  }
}
