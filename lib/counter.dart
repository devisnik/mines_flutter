import 'package:flutter/material.dart';

class _Digit extends StatelessWidget {
  const _Digit({Key key, this.value, this.size}) : super(key: key);

  final int value;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return new Image.asset(
      'assets/images/counter_$value.gif',
      fit: BoxFit.fill,
      width: size.width,
      height: size.height,
      gaplessPlayback: true,
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({Key key, this.value}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    var size = new Size(20.0, 35.0);
    return new Row(
      children: <Widget>[
        new _Digit(
          value: (value / 100).floor() % 10,
          size: size,
        ),
        new _Digit(
          value: (value / 10).floor() % 10,
          size: size,
        ),
        new _Digit(
          value: value % 10,
          size: size,
        ),
      ],
    );
  }
}
