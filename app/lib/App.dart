import 'package:flutter/material.dart';
import 'screen/Ready.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '클린에어',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'NanumSquare'),
      home: Ready(),
    );
  }
}
