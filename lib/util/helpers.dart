import 'dart:math';

import 'package:flutter/material.dart';

void offsetCursor(TextEditingController controller) {
  controller.selection = TextSelection.fromPosition(
    TextPosition(offset: controller.text.length),
  );
}


extension ToRadians on double {
  double toRadians() => this / 180 * pi;
}

extension RemoveNull on Map<String, dynamic> {
  void removeNull() => removeWhere((key, value) => value == null);
}

extension DoubleExtensions on num {
  String to2dp() => toStringAsFixed(2);
}
