part of 'login_cubit.dart';

class LoginState {
  final String email;
  final String? errorMessage;
  final bool routeToVerifyMail;
  final bool userNotFound;

  const LoginState({
    this.email = '',
    this.errorMessage,
    this.routeToVerifyMail = false,
    this.userNotFound = false,
  });

  LoginState copyWith({
    String? newEmail,
    String? newErrorMessage,
    bool? routeToVerifyMail,
    bool? userNotFound,
  }) =>
      LoginState(
        email: newEmail ?? email,
        errorMessage: newErrorMessage ?? errorMessage,
        routeToVerifyMail: routeToVerifyMail ?? this.routeToVerifyMail,
        userNotFound: userNotFound ?? this.userNotFound,
      );

  bool get isEmailValid => Validators.emailValidator(email) == null;
}
