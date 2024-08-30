import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/asset_paths.dart';
import 'package:new_project_template/assets/text_styles.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Center(child: SvgPicture.asset('')),
          gapH16,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.s18w400,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
