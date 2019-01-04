import 'dart:async';

import 'package:logging/logging.dart';

/**
 * server.dart
 *
 * Purpose:
 *
 * Description:
 *
 * History:
 *   26/07/2017, Created by jumperchen
 *
 * Copyright (C) 2017 Potix Corporation. All Rights Reserved.
 */
import 'package:socket_io_client/socket_io_client.dart';
import 'package:test/test.dart';

main() {
  group('test client', () {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    test('cleans up unneeded noise from movie names', () {
      Socket socket = io('ws://localhost:3000/', {
        'transports': ['websocket'],
        'secure': false
      });
      socket.on('connect', (_) {
        print('connect');
        socket.emit('msg', 'test');
      });
      socket.on('event', (data) => print(data));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));

      new Timer(const Duration(seconds: 20), ()=>print("20 second later."));

    });
  });
}
