import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/domain/models/request_error_model.dart';
import 'package:new_project_template/domain/services/user_auth_service.dart';
import 'package:new_project_template/util/enums.dart';
import 'package:new_project_template/util/log_service.dart';
import 'package:new_project_template/util/validators.dart';

part 'create_account_state.dart';

@injectable
class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthService _authService;

  CreateAccountCubit(
    this._authService,
    @factoryParam String? initialEmail,
  ) : super(CreateAccountFormState(email: initialEmail ?? ''));

  void _createAccount({
    required Future<void> authFunction,
    required bool routeToVerifyMail,
  }) async {
    try {
      emit(CreateAccountLoading(
        email: state.email,
        acceptedTerms: state.acceptedTerms,
      ));
      await authFunction;
      emit(CreateAccountSuccess(
        email: state.email,
        routeToVerifyMail: routeToVerifyMail,
      ));
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on account creation');
      emit(
        CreateAccountError(
          email: state.email,
          routeToLogin: error is RequestErrorModel &&
              (error.message == HttpErrorCodes.AlreadyExists.name ||
                  error.errorCode == HttpErrorCodes.AlreadyExists.errorCode),
          acceptedTerms: state.acceptedTerms,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void createUserWithEmail() => _createAccount(
        authFunction: _authService.authWithEmail(email: state.email),
        routeToVerifyMail: true,
      );

  void setEmail(String value) {
    emit(CreateAccountFormState.copyWith(
      email: value,
      previousState: state,
    ));
  }

  void toggleTerms() {
    emit(CreateAccountFormState.copyWith(
      previousState: state,
      acceptedTerms: !state.acceptedTerms,
    ));
  }
}
