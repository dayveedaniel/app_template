import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_project_template/data/local/secure_storage.dart';
import 'package:web_socket_channel/io.dart';

const _wsUrl = String.fromEnvironment('WS_URL');

@singleton
class WebSocketClient {
  IOWebSocketChannel? _channel;

  IOWebSocketChannel? get channel => _channel;

  Future<void> createChannel() async {
    final token = await SecureStorage.read(key: StorageKeys.accessToken);

    if (token != null) {
      _channel = IOWebSocketChannel.connect(Uri.parse(_wsUrl), headers: {
        "access_token": token,
      });
    }
  }

  Future<void> reconnect() async {
    await closeSocket();
    _channel = null;
    await createChannel();
  }

  Future<void> closeSocket() async {
    await _channel?.sink.close();
  }
}
