import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:appmanga/core/storage/token_manager.dart';
import 'package:appmanga/core/constants/api_constants.dart';

class SocketClient {
  IO.Socket? _socket;
  final TokenManager _tokenManager;

  SocketClient(this._tokenManager);

  Future<void> connect() async {
    final token = await _tokenManager.getAccessToken();
    if (token == null) return;

    // Sử dụng baseUrl từ ApiConstants nhưng loại bỏ phần /api nếu cần
    // Backend đang listen Socket.IO ở root (http://10.0.2.2:3000)
    final String socketUrl = ApiConstants.baseUrl.replaceAll('/api', '');

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) => debugPrint('✓ Socket connected'));
    _socket!.onDisconnect((_) => debugPrint('✗ Socket disconnected'));
    _socket!.onConnectError((err) => debugPrint('Socket error: $err'));
  }

  void onNotification(void Function(Map<String, dynamic>) callback) {
    _socket?.on('notification', (data) {
      if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
