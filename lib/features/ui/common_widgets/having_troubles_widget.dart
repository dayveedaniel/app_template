import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';

class HavingTroublesWidget extends StatelessWidget {
  const HavingTroublesWidget({
    super.key,
    required this.textKey,
    this.preButtonTextKey,
    this.hasSupport = false,
  });

  final bool hasSupport;
  final String textKey;
  final String? preButtonTextKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$textKey.troubles'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.s14w400.apply(color: AppColors.white),
        ),
        if (hasSupport) ...[
          gapH4,
          Text(
            'personal.support'.tr(),
            style: AppTextStyles.s14w400.apply(color: AppColors.white),
          ),
        ],
        ContactText(
          emailSubjectKey: textKey,
          preButtonTextKey: preButtonTextKey,
        )
      ],
    );
  }
}

class ContactText extends StatefulWidget {
  const ContactText({
    super.key,
    required this.emailSubjectKey,
    this.preButtonTextKey,
    this.style = AppTextStyles.s14w400,
  });

  final String emailSubjectKey;
  final String? preButtonTextKey;
  final TextStyle style;

  @override
  State<ContactText> createState() => _ContactTextState();
}

class _ContactTextState extends State<ContactText> {
  late final TapGestureRecognizer recognizer;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    recognizer = TapGestureRecognizer()
      ..onTapDown = (details) {
        isPressed = true;
        setState(() {});
      }
      ..onTapUp = (details) {
        isPressed = false;
        setState(() {});
      };
  }

  @override
  void dispose() {
    recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '${(widget.preButtonTextKey ?? 'profile.contact').tr()} ',
        style: widget.style.apply(color: AppColors.white),
        children: [
          TextSpan(
            text: 'profile.support'.tr(),
            recognizer: recognizer,
            style: AppTextStyles.s14w500.apply(
              color: isPressed ? AppColors.black : Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor:
                  isPressed ? AppColors.white : Colors.blue,
            ),
          ),
        ],
      ),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
