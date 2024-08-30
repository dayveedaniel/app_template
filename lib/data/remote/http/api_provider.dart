import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:new_project_template/data/local/secure_storage.dart';
import 'package:new_project_template/domain/models/user_model.dart';

import 'core/http_client.dart';
import 'core/i_http_client.dart';

@singleton
class ApiProvider {
  ApiProvider() {
    setToken();
  }

  final BaseHttpClient _httpClient = MHttpClient();
}

extension Authorization on ApiProvider {
  Stream<bool> get unAuthStream => (_httpClient as MHttpClient).errorStream;

  void closeStream() => (_httpClient as MHttpClient).closeStream();

  Future<void> setToken([bool isBearer = false]) async =>
      _httpClient.setToken(isBearer);

  Future<Map<String, dynamic>> authWithEmail({
    required UserAuthData data,
    bool isCreateAccount = true,
  }) async {
    final endPoint = isCreateAccount ? 'create_in-house' : 'recover';
    final value = await _httpClient
        .post(
          query: 'User/$endPoint',
          data: data.toJson(),
        )
        .whenComplete(() async => await SecureStorage.clearStorage());
    return value;
  }

  Future<Map<String, dynamic>> verifyOtpInMail({
    required String email,
    required String specialToken,
    required String deviceId,
  }) async =>
      await _httpClient.get(
        query: 'User/validate',
        queryParameters: {
          'email': email,
          'specialToken': specialToken,
          "deviceId": deviceId,
        },
      );

  Future<Map<String, dynamic>> externalUserAuth({
    required UserAuthData data,
    required String authType,
  }) async {
    final value = await _httpClient
        .post(
          query: 'User/$authType',
          data: data.toJson(),
        )
        .whenComplete(() async => await SecureStorage.clearStorage());
    return value;
  }

  Future<Map<String, dynamic>> getUserInfo() async =>
      await _httpClient.get(query: 'Auth/user');

  Future<void> deleteUser() async =>
      await _httpClient.get(query: 'User/Delete');
}
