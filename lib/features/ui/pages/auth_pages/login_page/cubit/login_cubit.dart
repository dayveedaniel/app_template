import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/domain/models/request_error_model.dart';
import 'package:new_project_template/domain/services/user_auth_service.dart';
import 'package:new_project_template/util/enums.dart';
import 'package:new_project_template/util/log_service.dart';
import 'package:new_project_template/util/validators.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._authService,
    @factoryParam String? initialEmail,
  ) : super(LoginState(email: initialEmail ?? ''));

  final AuthService _authService;

  void loginWithEmail() => _login(
        authFunction: _authService.authWithEmail(
          email: state.email,
          isCreateAccount: false,
        ),
        routeToVerifyMail: true,
      );

  void _login({
    required Future<void> authFunction,
    required bool routeToVerifyMail,
  }) async {
    try {
      emit(state.copyWith());
      await authFunction;
      emit(state.copyWith(
        routeToVerifyMail: routeToVerifyMail,
      ));
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on login');
      emit(
        state.copyWith(
          newErrorMessage: error.toString(),
          userNotFound: error is RequestErrorModel &&
              (error.message == HttpErrorCodes.UserNotFound.name ||
                  error.errorCode == HttpErrorCodes.UserNotFound.errorCode),
        ),
      );
    }
  }
}
