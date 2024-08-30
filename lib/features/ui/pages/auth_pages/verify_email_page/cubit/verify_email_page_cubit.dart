import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/domain/services/user_auth_service.dart';
import 'package:new_project_template/util/log_service.dart';

part 'verify_email_page_state.dart';

@injectable
class VerifyEmailPageCubit extends Cubit<VerifyEmailPageState> {
  VerifyEmailPageCubit(
    this._authService,
    @factoryParam this.email,
  ) : super(const VerifyEmailPageState(newCodeTime: '60s')) {
    _startNewCodeTimer();
  }

  final AuthService _authService;
  final String email;
  Timer? timer;
  int requestNewMailCount = 0;

  StreamSubscription<int>? sendNewCodeSub;

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }

  void _startNewCodeTimer() {
    sendNewCodeSub?.cancel();
    sendNewCodeSub = tick(ticks: 60).listen((event) {
      emit(state.copyWith(newCodeTime: '${event}s'));
    }, onDone: () {
      emit(state.copyWith(canSendNewCode: true));
    });
  }


  Future<void> resendMail() async {
    try {
      emit(state.copyWith());
      await _authService.authWithEmail(
        email: email,
        isCreateAccount: false,
      );
      _startNewCodeTimer();
      ++requestNewMailCount;
      emit(
        state.copyWith(
          newCodeTime: '60s',
          showNoEmailButton: requestNewMailCount > 0,
          canSendNewCode: false,
        ),
      );
    } catch (error, trace) {
      println('$error trace $trace', tag: '=> Error on requesting mail');
      emit(state.copyWith());
    }
  }

  @override
  Future<void> close() {
    timer?.cancel();
    sendNewCodeSub?.cancel();
    return super.close();
  }
}
