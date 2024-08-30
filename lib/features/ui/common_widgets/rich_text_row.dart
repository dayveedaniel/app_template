import 'package:flutter/material.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/text_styles.dart';

class RichTextRow extends StatelessWidget {
  const RichTextRow({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: AppTextStyles.s16w400.apply(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
