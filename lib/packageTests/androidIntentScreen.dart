import 'dart:io';

import 'package:flutter/material.dart';

import 'package:android_intent/android_intent.dart';

class AndroidIntentScreen extends StatelessWidget {
  Future<void> _callFrotalogCondutorPackage() async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        category: 'DEFAULT',
        componentName: 'package:com.crearesistemas.frotalog_condutor',
        package: 'package:com.crearesistemas.frotalog_condutor',
      );
      await intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Android Intent')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Call Frotalog Condutor using package'),
              onPressed: _callFrotalogCondutorPackage,
            ),
          ],
        ),
      ),
    );
  }
}
