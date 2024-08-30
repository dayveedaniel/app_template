import 'package:dio/dio.dart';
import 'package:new_project_template/features/mixins/cancel_token_mixin.dart';
import 'package:new_project_template/features/mixins/completable_timer_mixin.dart';

mixin SearchMixin {
  final CompletableTimerMixin _deBouncer = CompletableTimerMixin();
  final CancelTokenMixin _cancelTokenMixin = CancelTokenMixin();

  CancelToken? get cancelToken => _cancelTokenMixin.cancelToken;

  Future<void> search(String searchString);

  Future<void> searchWithDebounce(String searchString) async {
    _cancelTokenMixin.requestCancelToken();
    if (await _deBouncer.handleTimer()) {
      search(searchString);
    }
  }
}
