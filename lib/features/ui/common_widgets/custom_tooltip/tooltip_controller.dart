import 'dart:async';

import 'package:flutter/material.dart';

import 'tooltip_enums.dart';

class TooltipController extends ChangeNotifier {
  late Completer _completer;
  bool _isVisible = false;
  bool get isVisible => _isVisible;

  late Event event;

  Future<void> showTooltip() {
    event = Event.show;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = true);
  }

  Future<void> hideTooltip() {
    event = Event.hide;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = false);
  }

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}
