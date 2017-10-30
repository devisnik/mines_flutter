import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.light,
          canvasColor: Colors.yellow
      ),
      home: new MyHomePage(title: 'Mines'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _startTimer() {
    new Timer.periodic(new Duration(seconds: 1), _incTimer);
    _isRunning = true;
  }

  void _incTimer(Timer timer) {
    setState(() {
      _seconds++;
    });
  }

  List<List<int>> _state = [
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
    [10, 10, 10, 10, 10, 10, 10, 10],
  ];

  int _flagsToSet = 30;
  int _seconds = 0;
  bool _isRunning = false;

  void _openField(int row, int column) {
    setState(() {
      if (!_isRunning) _startTimer();
      _state[row][column] = column % 8 + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Counter(
                value: _flagsToSet,
              ),
              new Counter(
                value: _seconds,
              ),
            ],
          ),
          new Center(
            child: new Board(
              ids: _state,
              size: MediaQuery
                  .of(context)
                  .size
                  .width,
              onClick: _openField,
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {

  final int id;
  final double size;
  final VoidCallback onClick;

  const Tile({Key key, this.id, this.size, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: onClick,
        child: new Image.asset(
          "assets/images/classic_image_${id < 10 ? "0$id" : "$id"}.png",
          width: size,
          height: size,
        )
    );
  }
}

typedef void ColumnCallback(int);

class TileRow extends StatelessWidget {

  final List<int> ids;
  final double width;
  final ColumnCallback onClick;

  const TileRow({Key key, this.ids, this.width, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    ids.asMap().forEach((index, id) =>
        tiles.add(
            new Tile(
              id: id,
              size: width / ids.length,
              onClick: () => onClick(index),
            )
        )
    );
    return new Row(
        children: tiles
    );
  }
}

typedef void RowColumnCallback(int row, int column);

class Board extends StatelessWidget {

  final List<List<int>> ids;
  final double size;
  final RowColumnCallback onClick;

  const Board({this.ids, this.size, this.onClick});

  @override
  Widget build(BuildContext context) {
    List<TileRow> rows = [];
    ids.asMap().forEach((rowIndex, values) =>
        rows.add(
            new TileRow(
              ids: values,
              width: size,
              onClick: (columnIndex) => onClick(rowIndex, columnIndex),
            )
        )
    );
    return new Column(
        children: rows
    );
  }
}

class Digit extends StatelessWidget {

  const Digit({Key key, this.value, this.size}) : super(key: key);

  final int value;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return new Image.asset(
      'assets/images/counter_$value.gif',
      fit: BoxFit.fill,
      width: size.width,
      height: size.height,
    );
  }
}

class Counter extends StatelessWidget {

  const Counter({Key key, this.value}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Digit(
          value: (value / 100).floor() % 10,
          size: new Size(26.0, 46.0),
        ),
        new Digit(
          value: (value / 10).floor() % 10,
          size: new Size(26.0, 46.0),
        ),
        new Digit(
          value: value % 10,
          size: new Size(26.0, 46.0),
        ),
      ],
    );
  }
}
