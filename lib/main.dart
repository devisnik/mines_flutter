import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(new MinesApp());
}

class MinesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Mines',
      theme: new ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
        canvasColor: Colors.white,
      ),
      home: new GamePage(title: 'Mines'),
    );
  }
}
