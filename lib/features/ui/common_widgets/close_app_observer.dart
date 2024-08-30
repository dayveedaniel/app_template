import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/util/alert_utils.dart';

class CloseAppObserver extends StatelessWidget {
  final Widget child;

  const CloseAppObserver({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool args) async {
        AlertUtils.showBottomSheet(
          parentContext: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'alert.confirm_'.tr(),
                style: AppTextStyles.s18w600,
              ),
              gapH8,
              Text(
                'alert.confirmCloseApp'.tr(),
                style: AppTextStyles.s16w400.apply(color: AppColors.white),
              ),
              gapH24,
              FilledCustomButton(
                textKey: 'buttons.closeApp',
                onPressed: () => SystemNavigator.pop(),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
