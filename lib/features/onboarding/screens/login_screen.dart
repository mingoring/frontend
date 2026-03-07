import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_icon_assets.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../constants/login_screen_constants.dart';
import '../widgets/social_icon_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const _characterWidth = 270.0;
  static const _socialIconSize = 52.0;
  static const _dividerHorizontalPadding = 20.0;
  static const _dividerTextGap = 18.0;
  static const _socialGap = 14.0;
  static const _dividerThickness = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink600,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 17),
            Text(
              LoginScreenConstants.titleText,
              style: AppLogoTypography.logoEb3.copyWith(
                color: AppColors.pink50,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LoginScreenConstants.titleToSubtitleGap),
            Text(
              LoginScreenConstants.subtitleText,
              style: AppTextStyles.body5Sb15.copyWith(
                color: AppColors.pink50,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 9),
            SizedBox(
              width: _characterWidth,
              child: SvgPicture.asset(
                AppImages.mingoWithGreeting,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(flex: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _dividerHorizontalPadding,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.pink400,
                      thickness: _dividerThickness,
                      height: _dividerThickness,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _dividerTextGap,
                    ),
                    child: Text(
                      LoginScreenConstants.dividerText,
                      style: AppTextStyles.detail6Md12.copyWith(
                        color: AppColors.pink400,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: AppColors.pink400,
                      thickness: _dividerThickness,
                      height: _dividerThickness,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: LoginScreenConstants.dividerToSocialGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIconButton(
                  iconPath: AppIconAssets.google,
                  iconSize: _socialIconSize,
                  onTap: () => context.push(RouteNames.terms),
                ),
                const SizedBox(width: _socialGap),
                SocialIconButton(
                  iconPath: AppIconAssets.apple,
                  iconSize: _socialIconSize,
                  onTap: () => context.push(RouteNames.terms),
                ),
              ],
            ),
            const SizedBox(height: LoginScreenConstants.socialToGuestGap),
            InkWell(
              onTap: () {},
              child: Text(
                LoginScreenConstants.guestText,
                style: AppTextStyles.body4B15.copyWith(
                  color: AppColors.pink50,
                  height: 1.2,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.pink50,
                ),
              ),
            ),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }
}
