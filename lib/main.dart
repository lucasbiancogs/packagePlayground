import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:packagePlayground/appRoutes.dart';
import 'package:packagePlayground/packageTests/android_intent.dart';
import 'package:packagePlayground/packageTests/background_location.dart';
import 'package:packagePlayground/packageTests/ffi_screen.dart';
import 'package:packagePlayground/packageTests/isolate_screen.dart';

void main() async {
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      routes: {
        AppRoutes.ANDROID_INTENT: (_) => AndroidIntentScreen(),
        AppRoutes.FFI: (_) => FfiScreen(),
        AppRoutes.ISOLATE: (_) => IsolateScreen(),
        AppRoutes.BACKGROUND_LOCATION: (_) => BackgroundLocationScreen(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Playground'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Package Playground',
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              child: Text(
                'Android Intents',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.ANDROID_INTENT);
              },
            ),
            ElevatedButton(
              child: Text(
                'Ffi',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.FFI);
              },
            ),
            ElevatedButton(
              child: Text(
                'Isolates',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.ISOLATE);
              },
            ),
            ElevatedButton(
              child: Text(
                'Background location',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.BACKGROUND_LOCATION);
              },
            ),
          ],
        ),
      ),
    );
  }
}
