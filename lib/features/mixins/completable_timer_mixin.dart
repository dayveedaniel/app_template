import 'dart:async';

import 'package:new_project_template/util/consts.dart';

mixin class CompletableTimerMixin {
  Timer? _timer;

  Future<bool> handleTimer() async {
    _timer?.cancel();

    final timerData = _completableTimer(duration_500ms);
    _timer = timerData.timer;
    return await timerData.isCompleted;
  }

  ({Timer timer, Future<bool> isCompleted}) _completableTimer(
      Duration duration) {
    final completer = Completer<bool>();
    final timer = Timer(duration, () => completer.complete(true));
    return (timer: timer, isCompleted: completer.future);
  }
}
