import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';

import '../loading_indicator.dart';
import 'custom_button.dart';

class FilledCustomButton extends CustomButton {
  const FilledCustomButton({
    required super.onPressed,
    super.textColor = AppColors.white,
    super.inActiveTextColor = AppColors.white,
    super.buttonColor = AppColors.black,
    super.inActiveButtonColor = AppColors.white,
    super.textKey,
    super.child,
    super.padding,
    super.isLoading,
    super.isActive,
    super.textStyle,
    super.key,
    super.height,
    super.width,
    super.alignment,
    this.border,
  });

  const FilledCustomButton.secondary({
    required super.onPressed,
    super.textKey,
    super.child,
    super.padding,
    super.isLoading,
    super.isActive,
    super.textStyle,
    super.key,
    super.height,
    super.width,
    super.alignment,
    this.border,
  }) : super(
          textColor: AppColors.white,
          inActiveTextColor: AppColors.white,
          buttonColor: AppColors.white,
          inActiveButtonColor: AppColors.white,
        );

  const FilledCustomButton.childSize({
    required super.onPressed,
    super.textKey,
    super.child,
    super.padding,
    super.isLoading,
    super.isActive,
    super.textStyle,
    super.key,
    super.height = null,
    super.width = null,
    super.alignment = null,
    this.border,
  }) : super(
          textColor: AppColors.white,
          buttonColor: AppColors.white,
          inActiveTextColor: AppColors.white,
          inActiveButtonColor: AppColors.white,
        );

  const FilledCustomButton.childSizeSecondary({
    required super.onPressed,
    super.textKey,
    super.child,
    super.padding,
    super.isLoading,
    super.isActive,
    super.textStyle,
    super.key,
    super.height = null,
    super.width = null,
    super.alignment = null,
    this.border,
  }) : super(
          textColor: AppColors.white,
          inActiveTextColor: AppColors.white,
          buttonColor: AppColors.white,
          inActiveButtonColor: AppColors.white,
        );

  FilledCustomButton.outlined({
    required super.onPressed,
    super.textKey,
    super.child,
    super.padding,
    super.isLoading,
    super.isActive,
    super.textStyle,
    super.key,
    super.height,
    super.width,
    super.alignment,
  })  : border = Border.all(
          color: isLoading || !isActive ? AppColors.white : AppColors.white,
        ),
        super(
          textColor: AppColors.white,
          buttonColor: AppColors.white,
          inActiveTextColor: AppColors.white,
          inActiveButtonColor: AppColors.white,
        );

  final Border? border;

  bool get isInActive => isLoading || !isActive;

  @override
  Widget build(BuildContext context) {
    final button = CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isInActive ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: alignment,
        padding: padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          border: border,
          color: isInActive ? inActiveButtonColor : buttonColor,
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        child: isLoading
            ? LoadingIndicator(color: textColor)
            : child ??
                Text(
                  textKey!.tr(),
                  style: textStyle.copyWith(
                    color: isInActive ? inActiveTextColor : textColor,
                  ),
                ),
      ),
    );
    return button;
  }
}
