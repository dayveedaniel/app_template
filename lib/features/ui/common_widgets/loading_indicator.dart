import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_project_template/assets/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.iosScaleFactor = 1.0,
    this.androidScaleFactor = 0.6,
  });

  final Color? color;
  final double iosScaleFactor, androidScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: Platform.isIOS ? iosScaleFactor : androidScaleFactor,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: color,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}
