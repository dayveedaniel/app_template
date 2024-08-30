import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/data/local/secure_storage.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/domain/models/request_error_model.dart';
import 'package:new_project_template/util/enums.dart' show HttpErrorCodes;
import 'package:new_project_template/util/log_service.dart';
import 'i_http_client.dart';

const _baseUrl = String.fromEnvironment('BASE_URL');

typedef PendingRequest = ({
  RequestOptions options,
  ErrorInterceptorHandler handler
});

@Injectable(as: BaseHttpClient, env: [Environment.dev])
class MHttpClient extends _HttpClient {
  MHttpClient()
      : super(
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              // connectTimeout: duration_30s,
              // receiveTimeout: duration_30s,
              headers: {
                Headers.contentTypeHeader: Headers.jsonContentType,
              },
            ),
          ),
        );
}

class _HttpClient implements BaseHttpClient {
  final Dio _dio;

  final StreamController<bool> _unAuthorizedUserStream = StreamController();

  Stream<bool> get errorStream => _unAuthorizedUserStream.stream;

  final List<PendingRequest> pendingRequests = [];

  bool isRefreshingToken = false;

  void closeStream() => _unAuthorizedUserStream.close();

  String? _accessToken;

  _HttpClient(this._dio) {
    _setInterceptors();
    HttpOverrides.global = MyHttpOverrides();
  }

  @override
  Future<void> setToken([bool isBearer = false]) async {
    _accessToken = await SecureStorage.read(key: StorageKeys.accessToken);
    if (_accessToken != null) {
      final authHeaderPrefix = isBearer ? 'Bearer ' : '';
      _dio.options.headers["Authorization"] =
          "$authHeaderPrefix${_accessToken!}";
    }
    isRefreshingToken = false;
  }

  @override
  Future get({
    required query,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    return await _sendRequest(_dio.get(
      query,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: progressCallback,
    ));
  }

  @override
  Future post({
    required query,
    Object? data,
    CancelToken? cancelToken,
  }) async =>
      await _sendRequest(
        _dio.post(
          query,
          data: data,
          cancelToken: cancelToken,
        ),
      );

  @override
  Future put({
    required query,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) async =>
      await _sendRequest(_dio.put(query, data: data));

  @override
  Future patch({
    required query,
    Map<String, dynamic>? data,
  }) async =>
      await _sendRequest(_dio.patch(query, data: data));

  @override
  Future fetch(RequestOptions requestOptions) async =>
      await _sendRequest(_dio.fetch(requestOptions));

  @override
  Future delete({
    required query,
    Map<String, dynamic>? data,
  }) async =>
      await _sendRequest(_dio.delete(query, data: data));

  Future<void> _refreshToken() async {
    final accessToken = await SecureStorage.read(key: StorageKeys.accessToken);
    final refreshToken =
        await SecureStorage.read(key: StorageKeys.refreshToken);

    _dio.options.headers.remove('Authorization');

    final responseData = await post(
      query: "Auth/refresh_token",
      data: {
        "token": accessToken,
        "refreshToken": refreshToken,
      },
    );
    await Future.wait([
      SecureStorage.write(
        key: StorageKeys.accessToken,
        value: responseData["token"],
      ),
      SecureStorage.write(
        key: StorageKeys.refreshToken,
        value: responseData["refreshToken"],
      )
    ]);
    await setToken();
  }

  Future _sendRequest(Future<Response> request) async {
    final Response response = await request.catchError(
      (error) {
        if (error is DioException) {
          throw (error.response?.data == null || error.response?.data.isEmpty)
              ? RequestErrorModel.dioError(error)
              : RequestErrorModel.fromJson(
                  error.response?.data['errors'][0],
                  error.response?.statusCode,
                );
        }
        return error;
      },
    );
    final result = response.data is! Map<String, dynamic>
        ? response.data
        : response.data?['item'] ?? response.data?['items'];
    return result ?? false;
  }

  Future<void> _setInterceptors() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
      ),
    );
  }

  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    println("[ ${DateTime.now().toUtc()} ]"
        "\n---------- DioRequest ----------"
        "\n\turl: ${options.baseUrl}${options.path}"
        "\n\tquery: ${options.queryParameters}"
        "\n\tmethod: ${options.method}"
        "\n\tdata: ${options.data}"
        "\n\theaders: ${options.headers}\n}"
        "\n--------------------------------\n");
    return handler.next(options);
  }

  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    println("[ ${DateTime.now().toUtc()} ]"
        "\n---------- DioResponse ----------"
        "\n\turl: ${options.baseUrl}${options.path}"
        "\n\tmethod: ${options.method}"
        "\n\tresponse: $response"
        "\n--------------------------------\n");
    return handler.next(response);
  }

  void onError(DioException error, ErrorInterceptorHandler handler) async {
    final options = error.requestOptions;
    println("[ ${DateTime.now().toUtc()} ]"
        "\n---------- DioError ----------"
        "\n\turl: ${options.baseUrl}${options.path}"
        "\n\tmethod: ${options.method}"
        "\n\tmessage: ${error.message}"
        "\n\tresponse: ${error.response}"
        "\n\terrorCode: ${error.response?.statusCode}"
        "\n--------------------------------\n");
    if (error.response?.statusCode ==
            HttpErrorCodes.NotAllowedInTariff.errorCode &&
        error.response != null) {
      return handler.resolve(error.response!);
    }
    if (error.type == DioExceptionType.cancel) return;
    if (options.path == 'Auth/refresh_token' &&
        error.response?.statusCode ==
            HttpErrorCodes.RefreshTokenExpired.errorCode &&
        isRefreshingToken) {
      //isRefreshingToken = false;
      pendingRequests.clear();
      _unAuthorizedUserStream.add(true);
      return;
    } else if (error.response?.statusCode ==
        HttpErrorCodes.AccessTokenExpired.errorCode) {
      pendingRequests.add((options: options, handler: handler));
      if (!isRefreshingToken) {
        isRefreshingToken = true;
        await _refreshToken();
        println('----------- Retrying Requests ----------');
        for (final request in pendingRequests) {
          println('------ Retrying ${request.options.path} --------');
          request.options.headers = _dio.options.headers;
          request.handler.resolve(await _dio.fetch(request.options));
        }
        pendingRequests.clear();
      }
      return;
    }
    return handler.next(error);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
