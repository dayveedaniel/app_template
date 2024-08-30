import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/features/ui/common_widgets/loading_indicator.dart';
import 'package:new_project_template/util/consts.dart';

Widget materialDialog(Widget? content) => AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Sizes.p14),
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      content: content,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p24),
        side: BorderSide(
          color: AppColors.black.withOpacity(0.3),
        ),
      ),
    );

abstract class AlertUtils {
  static SnackBar snackBar({
    required String messageKey,
    SnackBarAction? action,
    Duration? duration,
    bool showLoading = false,
    bool isError = false,
  }) {
    return SnackBar(
      backgroundColor: isError ? AppColors.white : AppColors.black,
      duration: duration ?? duration_10s,
      behavior: SnackBarBehavior.floating,
      action: action,
      content: Row(
        children: [
          Expanded(
            child: Text(
              messageKey,
              style: AppTextStyles.s16w400,
            ),
          ),
          if (showLoading) const LoadingIndicator(),
        ],
      ),
    );
  }


  static Future showCustomDialog({
    required BuildContext context,
    VoidCallback? onButtonPressed,
    bool isDismissible = false,
    bool useNativeDialog = false,
    String? titleKey,
    String? bodyText,
    String? buttonTextKey,
    String? secondButtonTextKey,
    TextStyle? titleStyle,
    TextStyle? bodyStyle,
    VoidCallback? onSecondButtonPressed,
    Widget? body,
    Widget? titleWidget,
    bool isFirstButtonDestructive = false,
    bool popOnFirstPressed = true,
  }) async {
    final title = titleKey != null
        ? Text(
            titleKey.tr(),
            style: titleStyle ?? AppTextStyles.s24w400,
            textAlign: TextAlign.center,
          )
        : titleWidget;

    final contentBody = bodyText != null
        ? Text(
            bodyText,
            style: bodyStyle ?? AppTextStyles.s18w400,
            textAlign: TextAlign.center,
          )
        : body;

    final content = Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) title,
          gapH16,
          if (contentBody != null) contentBody,
          gapH16,
          if (buttonTextKey != null)
            FilledCustomButton(
              height: Sizes.p48,
              onPressed: () {
                if (popOnFirstPressed) Navigator.pop(context, true);
                onButtonPressed?.call();
              },
              textKey: buttonTextKey,
            ),
          if (secondButtonTextKey != null) ...[
            gapH8,
            FilledCustomButton.outlined(
              height: Sizes.p48,
              onPressed: () {
                Navigator.pop(context, false);
                onSecondButtonPressed?.call();
              },
              textKey: secondButtonTextKey,
            ),
          ]
        ],
      );
    });
    final cupertinoDialog = CupertinoAlertDialog(
      title: title,
      content: contentBody,
      actions: [
        if (buttonTextKey != null)
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context, true);
              onButtonPressed?.call();
            },
            isDestructiveAction: isFirstButtonDestructive,
            child: Text(buttonTextKey.tr()),
          ),
        if (secondButtonTextKey != null)
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context, false);
              onSecondButtonPressed?.call();
            },
            child: Text(secondButtonTextKey.tr()),
          ),
      ],
    );

    Platform.isAndroid
        ? await showDialog(
            context: context,
            barrierDismissible: isDismissible,
            builder: (context) => materialDialog(content),
          )
        : await showCupertinoDialog(
            context: context,
            barrierDismissible: isDismissible,
            builder: (context) =>
                useNativeDialog ? cupertinoDialog : materialDialog(content),
          );
  }

  static Future showBottomSheet({
    required BuildContext parentContext,
    required Widget child,
    bool useRootNavigator = false,
  }) {
    return showModalBottomSheet(
      context: parentContext,
      useRootNavigator: useRootNavigator,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(
            left: Sizes.p24,
            right: Sizes.p24,
            bottom: Sizes.p48,
          ),
          child: child,
        );
      },
    );
  }
}

class DropDownTitle extends StatelessWidget {
  const DropDownTitle({super.key, required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(titleKey.tr(), style: AppTextStyles.s20w600),
        spacer,
        IconButton(
          icon: SvgPicture.asset(''),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
