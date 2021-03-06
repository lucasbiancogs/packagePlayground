import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:native_add/native_add.dart';

class IsolateScreen extends StatefulWidget {
  @override
  _IsolateScreenState createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  int foregroundCount = 0;
  int backgroundCount = 0;
  SendPort mainToIsolateStream;
  ReceivePort isolateToMainStream;

  void startIsolate() async {
    final streams = await initIsolate();

    mainToIsolateStream = streams['sendPort'];
    isolateToMainStream = streams['receivePort'];

    mainToIsolateStream.send('Isolate iniciado');
    isolateToMainStream.listen((message) {
      if (message is BackgroundCounter) {
        setState(() {
          backgroundCount = message.counter;
        });
      }
      if (message is ForegroundCounter) {
        setState(() {
          foregroundCount = message.counter;
        });
      }
    });
  }

  void foregroundAdd() {
    setState(() {
      foregroundCount++;
    });

    mainToIsolateStream.send(foregroundCount);
  }

  void terminateIsolate() {
    mainToIsolateStream.send('stop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ISOLATE')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('foregroundCount: $foregroundCount'),
            Text('backgroundCount: $backgroundCount'),
            Text('Start Isolate'),
            ElevatedButton(
              onPressed: startIsolate,
              child: Icon(Icons.play_arrow),
            ),
            ElevatedButton(
              onPressed: foregroundAdd,
              child: Icon(Icons.add),
            ),
            Text('Stop Isolate'),
            ElevatedButton(
              onPressed: terminateIsolate,
              child: Icon(Icons.stop),
            ),
          ],
        ),
      ),
    );
  }
}
