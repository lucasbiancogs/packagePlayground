import 'package:flutter/material.dart';
import 'package:native_add/native_add.dart';

class FfiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FFI')),
      body: Center(
        child: Text('3 + 27 = ${nativeAdd(3, 27)}'),
      ),
    );
  }
}
