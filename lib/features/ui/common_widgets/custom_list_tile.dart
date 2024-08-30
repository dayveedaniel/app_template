import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.textKey,
    required this.endText,
    this.endTextColor,
  });

  final String textKey;
  final String endText;
  final Color? endTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.black),
        ),
      ),
      child: Row(
        children: [
          Text(
            textKey.tr(),
            style: AppTextStyles.s16w400,
          ),
          spacer,
          Text(
            endText,
            style: AppTextStyles.s18w500.apply(color: endTextColor),
          ),
        ],
      ),
    );
  }
}

class ListTileWithIcon extends StatelessWidget {
  const ListTileWithIcon({
    super.key,
    required this.textKey,
    required this.iconAsset,
    required this.onTap,
    this.bgColor = AppColors.white,
    this.icon = CupertinoIcons.arrow_right,
    this.textColor,
    this.extraEndWidgets,
    this.replaceArrowWidget,
  });

  final String textKey;
  final String iconAsset;
  final Widget? replaceArrowWidget;
  final IconData icon;
  final Color? textColor;
  final Color bgColor;
  final List<Widget>? extraEndWidgets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p16,
          horizontal: Sizes.p12,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        child: Row(
          children: [
            SizedBox(width: Sizes.p24, child: SvgPicture.asset(iconAsset)),
            gapW12,
            Text(
              textKey.tr(),
              style: AppTextStyles.s16w500.apply(color: textColor),
            ),
            spacer,
            gapW4,
            ...?extraEndWidgets,
            replaceArrowWidget ??
                Icon(
                  icon,
                  color: textColor?.withOpacity(0.4),
                ),
          ],
        ),
      ),
    );
  }
}
