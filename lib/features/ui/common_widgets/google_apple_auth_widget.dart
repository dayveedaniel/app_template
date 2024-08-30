import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';

final _divider = Expanded(
  child: Container(height: 1, color: AppColors.white),
);

class GoogleAppleAuthWidget extends StatelessWidget {
  const GoogleAppleAuthWidget({
    super.key,
    required this.onGoogleButtonPressed,
    required this.onAppleButtonPressed,
  });

  final VoidCallback onGoogleButtonPressed;
  final VoidCallback onAppleButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _divider,
            gapW8,
            Text(
              'createAccount.with'.tr(),
              style: AppTextStyles.s14w400.apply(color: AppColors.white),
            ),
            gapW8,
            _divider,
          ],
        ),
        gapH16,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetButton(
              onPressed: onAppleButtonPressed,
              child: SvgPicture.asset(''),
            ),
            gapW16,
            WidgetButton(
              onPressed: onGoogleButtonPressed,
              child: SvgPicture.asset(''),
            ),
          ],
        ),
      ],
    );
  }
}
