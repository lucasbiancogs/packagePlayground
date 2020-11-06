import 'package:flutter/material.dart';
import 'package:packagePlayground/appRoutes.dart';
import 'package:packagePlayground/packageTests/android_intent.dart';

void main() {
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
        AppRoutes.ANDROID_INTENT: (_) => AndroidIntentScreen()
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
              RaisedButton(
                child: Text(
                  'android_intent',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.ANDROID_INTENT
                  );
                },
              ),
            ],
          ),
        ),
      );
  }
}
