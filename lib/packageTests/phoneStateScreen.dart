import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';

class PhoneStateScreen extends StatelessWidget {
  _watchAllPhoneCallEvents() {
    FlutterPhoneState.phoneCallEvents.forEach((PhoneCallEvent event) {
      final phoneCall = event.call;
      final status = event.status;
      print("Got an event $event");
      print("status $status");
      print("phoneCall.callId ${phoneCall.callId}");
      print("phoneCall.id ${phoneCall.id}");
      print("phoneCall.done ${phoneCall.done}");
      print("phoneCall.duration ${phoneCall.duration}");
      print("phoneCall.isComplete ${phoneCall.isComplete}");
      print("phoneCall.phoneNumber ${phoneCall.phoneNumber}");
      print("phoneCall.startTime ${phoneCall.startTime}");
    });
    print("That loop ^^ won't end");
  }

  _watchAllRawEvents() {
    FlutterPhoneState.rawPhoneEvents.forEach((RawPhoneEvent event) {
      print("Got an event $event");
    });
    print("That loop ^^ won't end");
  }

  void initializePhoneStateWatch() {
    print('Phone state tracking initialized');
    _watchAllPhoneCallEvents();
    _watchAllRawEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone state')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: initializePhoneStateWatch,
              child: Text('Start phone tracking'),
            ),
          ],
        ),
      ),
    );
  }
}
