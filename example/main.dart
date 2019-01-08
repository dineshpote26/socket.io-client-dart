import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logging/logging.dart';

class ReadSender implements StreamConsumer<List<int>> {
  IO.Socket socket;

  ReadSender(IO.Socket this.socket);

  @override
  Future addStream(Stream<List<int>> stream) {
    return stream.transform(utf8.decoder).forEach((content){
      print(content);
      this.socket.emit("chat message",content);
    }).timeout(Duration(days: 30));
  }

  @override
  Future close() {
    // TODO: implement close
    return null;
  }
}

main() async {

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  stdout.writeln('Type something');

  IO.Socket socket = IO.io('ws://localhost:3000', {
    'secure': false,
    'path':'/socket.io',
    'transports':['polling','websocket']
  });
  socket.on('connect', (_) {
    print('connect happened');
    socket.emit('chat message', 'init');
  });
  socket.on('event', (data) => print("received "+data));
  socket.on('disconnect', (_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));
  await stdin.pipe(ReadSender(socket));
}
