import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:new_project_template/data/remote/web_socket/web_socket_client.dart';
import 'package:new_project_template/util/log_service.dart';

@injectable
class WebSocketService {
  WebSocketService(this._webSocket);

  final WebSocketClient _webSocket;

  final marketDataStream = StreamController<Map<String, dynamic>>.broadcast();

  Map<String, dynamic> _lastValue = {};
  Map<String, dynamic> get lastValue => _lastValue;

  Future<void> initClient() async {
    if (_webSocket.channel == null) {
      await _webSocket.createChannel();
      _listenWebSocket();
    }
  }

  Future<void> reconnect() async {
    await _webSocket.reconnect();
    _listenWebSocket();
  }

  void _listenWebSocket() {
    _webSocket.channel?.stream.listen(
      (message) {
        final Map<String, dynamic> decodedData = jsonDecode(message);
        final marketData = Map<String, dynamic>.fromIterables(
          decodedData.keys,
          decodedData.values.map((e) => e.toString()),
        );
        marketDataStream.add(marketData);
        _lastValue = marketData;
      },
      onError: (Object error, StackTrace trace) {
        println("Web Socket error $error trace $trace");
      },
      onDone: () {
        println("Web Socket closed");
        println(
            "code ${_webSocket.channel?.closeCode}......reason ${_webSocket.channel?.closeReason}");
      },
    );
  }

  Future<void> closeWebSocket() async {
    await _webSocket.closeSocket();
    await marketDataStream.close();
  }
}
