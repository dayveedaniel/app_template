import 'package:dio/dio.dart';

mixin class CancelTokenMixin {
  CancelToken? cancelToken;

  void requestCancelToken() {
    if (cancelToken != null) {
      cancelToken?.cancel();
    }
    cancelToken = CancelToken();
  }
}
