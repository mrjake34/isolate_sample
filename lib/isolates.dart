import 'dart:isolate';

void _isolateHandler(SendPort port) {
  port.send('Başlangıç');
}

final class IsolateController {
  static final _receivePort = ReceivePort();

  static ReceivePort get getPort => _receivePort;

  static Future<void> spawn() async {
    await Isolate.spawn(_isolateHandler, _receivePort.sendPort);
  }

  static Future<void> sendNewMessage(dynamic message) async {
    _receivePort.sendPort.send(message);
  }
}
