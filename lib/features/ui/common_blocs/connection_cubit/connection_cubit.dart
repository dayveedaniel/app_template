import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:new_project_template/data/remote/http/api_provider.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/domain/services/internet_connectivity_service.dart';
import 'package:new_project_template/features/ui/pages/profile_page/cubit/profile_page_cubit.dart';

part 'connection_state.dart';

@injectable
class ConnectionCubit extends Cubit<UserConnectionState> {
  ConnectionCubit(this._apiProvider) : super(ConnectionInitial()) {
    _listenToTokenError();
    _listenToInternetAvailability();
  }

  final ApiProvider _apiProvider;

  void _listenToTokenError() {
    _apiProvider.unAuthStream.listen((event) async {
      if (event) {
        await getIt.get<ProfilePageCubit>().logOut();
        emit(TokenExpiredError());
      }
    });
  }

  void _listenToInternetAvailability() {
    InternetConnectionService().initialize();
    InternetConnectionService().connectionChange.listen((hasConnection) {
      emit(InternetConnectionState(hasConnection));
    });
  }

  @override
  Future<void> close() async {
    _apiProvider.closeStream();
    InternetConnectionService().dispose();
    super.close();
  }
}
