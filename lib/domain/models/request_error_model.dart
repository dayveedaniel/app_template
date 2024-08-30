import 'package:dio/dio.dart' show DioException;

class RequestErrorModel implements Exception {
  RequestErrorModel({
    required this.message,
    required this.errorCode,
    this.description,
  });

  final int? errorCode;
  final String? message;
  final String? description;

  @override
  String toString() {
    return '$message Error Code $errorCode \n description: $description';
  }

  factory RequestErrorModel.fromJson(
    Map<String, dynamic> json, [
    int? errorCode,
  ]) =>
      RequestErrorModel(
        errorCode: errorCode,
        message: json["code"],
        description: json["description"],
      );

  factory RequestErrorModel.dioError(DioException error) => RequestErrorModel(
        errorCode: error.response?.statusCode,
        message: error.message ?? '',
      );
}
