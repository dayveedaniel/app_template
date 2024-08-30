part of 'create_account_cubit.dart';

abstract class CreateAccountState {
  final String email;
  final bool acceptedTerms;
  final bool routeToVerifyMail;

  const CreateAccountState({
    this.email = '',
    this.acceptedTerms = false,
    this.routeToVerifyMail = false,
  });
}

class CreateAccountFormState extends CreateAccountState {
  bool get canSubmitForm => isEmailValid && acceptedTerms;

  bool get isEmailValid => Validators.emailValidator(email) == null;

  const CreateAccountFormState({
    super.email,
    super.acceptedTerms,
    super.routeToVerifyMail,
  });

  factory CreateAccountFormState.copyWith({
    String? email,
    bool? acceptedTerms,
    required CreateAccountState previousState,
  }) =>
      CreateAccountFormState(
        acceptedTerms: acceptedTerms ?? previousState.acceptedTerms,
        email: email ?? previousState.email,
      );
}

class CreateAccountError extends CreateAccountState {
  final String errorMessage;
  final bool routeToLogin;

  const CreateAccountError({
    super.email,
    super.acceptedTerms,
    required this.routeToLogin,
    required this.errorMessage,
  });
}

class CreateAccountSuccess extends CreateAccountState {
  const CreateAccountSuccess({
    super.email,
    required super.routeToVerifyMail,
  });
}

class CreateAccountLoading extends CreateAccountState {
  const CreateAccountLoading({
    super.email,
    super.acceptedTerms,
  });
}
