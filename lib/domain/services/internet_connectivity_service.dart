import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_project_template/util/consts.dart';

class InternetConnectionService {
  static final InternetConnectionService _singleton =
      InternetConnectionService._internal();

  InternetConnectionService._internal();

  factory InternetConnectionService() => _singleton;

  bool hasConnection = true;
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionChange => connectionChangeController.stream;
  StreamController<bool> connectionChangeController = StreamController();

  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) => _checkConnection());
    _checkConnection();
  }

  void dispose() => connectionChangeController.close();

  Future<void> _checkConnection() async {
    bool previousConnection = hasConnection;
    try {
      await Future.delayed(duration_200ms);
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
  }
}
