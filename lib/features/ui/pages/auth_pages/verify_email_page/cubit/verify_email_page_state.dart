part of 'verify_email_page_cubit.dart';

class VerifyEmailPageState {
  final bool canSendNewCode;
  final bool isLinkInMailClicked;
  final bool showNoEmailButton;
  final String newCodeTime;

  const VerifyEmailPageState({
    this.isLinkInMailClicked = false,
    this.canSendNewCode = false,
    this.showNoEmailButton = false,
    this.newCodeTime = '',
  });


  VerifyEmailPageState copyWith({
    bool? canSendNewCode,
    bool? isLinkInMailClicked,
    bool? showNoEmailButton,
    String? newCodeTime,
  }) =>
      VerifyEmailPageState(
        canSendNewCode: canSendNewCode ?? this.canSendNewCode,
        newCodeTime: newCodeTime ?? this.newCodeTime,
        showNoEmailButton: showNoEmailButton ?? this.showNoEmailButton,
        isLinkInMailClicked: isLinkInMailClicked ?? this.isLinkInMailClicked,
      );
}
