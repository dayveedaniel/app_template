import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/data/local/secure_storage.dart';
import 'package:new_project_template/data/remote/http/api_provider.dart'
    show ApiProvider, Authorization;
import 'package:new_project_template/domain/models/user_model.dart';
import 'package:new_project_template/domain/repositories/user_repository.dart';
import 'package:new_project_template/util/consts.dart';

import 'analytics_service.dart';


@singleton
class AuthService {
  final ApiProvider _apiProvider;
  final UserRepository _userRepository;


  UserModel? get user => _userRepository.user;

  AuthService(this._apiProvider, this._userRepository);

  Future<bool> get noAccessToken async =>
      await SecureStorage.read(key: StorageKeys.accessToken) == null;

  Future<void> authWithEmail({
    required String email,
    bool isCreateAccount = true,
  }) async {
    final Map<String, dynamic> result = await _apiProvider.authWithEmail(
      data: UserAuthData(
        userId: email,
        email: email,
        name: email,
      ),
      isCreateAccount: isCreateAccount,
    );
    AppAnalytics.logSignUp('In House');
  }

  Future<void> _setToken(Map<String, dynamic> tokens) async {
    await Future.wait([
      SecureStorage.write(
        key: StorageKeys.accessToken,
        value: tokens['token'],
      ),
      SecureStorage.write(
        key: StorageKeys.refreshToken,
        value: tokens['refreshToken'],
      ),
    ]);
    await _apiProvider.setToken();
  }

  Future<void> deleteUserData() async {
    await _apiProvider.deleteUser();
    await Future.delayed(duration_500ms);
    await SecureStorage.clearStorage();
  }

  Future<void> getUserInfo() async {
    final data = await _apiProvider.getUserInfo();
    final user = UserModel.fromJson(data);
    _userRepository.updateUserData = user;
    AppAnalytics.setUserId(user.userId);
    FirebaseCrashlytics.instance.setUserIdentifier(user.email);
  }

  Future<void> signOut() async {
    await Future.delayed(duration_500ms);
    await SecureStorage.clearStorage();
  }
}
