import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.text,
    this.iconPath,
    this.onPressed,
    this.isColored = true,
    this.textColor,
    this.color,
    this.child,
    this.trailingWidget,
  });

  final String text;
  final String? iconPath;
  final VoidCallback? onPressed;
  final bool isColored;
  final Color? textColor;
  final Color? color;
  final Widget? child;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isColored
              ? (color ?? AppColors.white)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p16,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            children: [
              if (child != null) gapW12,
              if (iconPath != null) SvgPicture.asset(iconPath!),
              gapW8,
              Expanded(
                child: child ??
                    Text(
                      text.tr(),
                      style: AppTextStyles.s16w500
                          .copyWith(color: textColor ?? AppColors.black),
                    ),
              ),
              trailingWidget ??
                  RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset(''),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
