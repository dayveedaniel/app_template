import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/domain/models/user_model.dart';
import 'package:new_project_template/domain/services/user_auth_service.dart';
import 'package:new_project_template/util/log_service.dart';

part 'profile_page_state.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit(
    this._authService,
  ) : super(ProfilePageState(userProfile: _authService.user)) {
    initUserProfile();
  }

  final AuthService _authService;

  Future<void> initUserProfile() async {
    if (_authService.user == null) {
      getUserProfile();
    } else {
      await Future.delayed(Duration.zero);
      emit(state.copyWith(
        userProfile: _authService.user,
      ));
    }
  }

  Future<void> getUserProfile() async {
    try {
      emit(state.copyWith());
      await _authService.getUserInfo();
      emit(state.copyWith(
        userProfile: _authService.user,
      ));
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on getting user profile');
      emit(
        state.copyWith(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> logOut() async {
    try {
      emit(state.copyWith());
      await _authService.signOut();
      await getIt.reset();
      injectDependencies(env: Environment.dev);
      emit(state.copyWith());
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on logging out');
      emit(
        state.copyWith(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(state.copyWith());
      await _authService.deleteUserData();
      await getIt.reset();
      injectDependencies(env: Environment.dev);
      emit(state.copyWith());
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on deleting account');
      emit(
        state.copyWith(
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
