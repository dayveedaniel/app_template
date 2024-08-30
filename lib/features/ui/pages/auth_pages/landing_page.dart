import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/asset_paths.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';

import 'package:new_project_template/features/ui/pages/auth_pages/create_account_page/create_account_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const routeName = 'landingPage';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(ImageAssetPaths.landingPageBg),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              children: [
                gapH32,
                spacer,
                SvgPicture.asset(''),
                spacer,
                FilledCustomButton(
                  textColor: AppColors.black,
                  buttonColor: AppColors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      CreateAccountPage.routeName,
                    );
                  },
                  textKey: 'landing.create',
                ),
                gapH16,
                FilledCustomButton(
                  buttonColor: AppColors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      LoginPage.routeName,
                    );
                  },
                  textKey: 'landing.login',
                ),
                gapH48,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
