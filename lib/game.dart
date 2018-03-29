import 'dart:async';

import 'package:flutter/material.dart';

import 'board.dart';
import 'counter.dart';
import 'model.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => new _GamePageState();
}

typedef Future<GameState> Action();

class _GamePageState extends State<GamePage> {
  final Engine _engine = new Engine.native();

  List<List<int>> _state = [];
  int _flagsToSet = 0;
  int _seconds = 0;
  bool _isRunning = false;
  Timer _timer;

  _GamePageState() {
    _newGame(13, 10, 15);
  }

  void _startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), _incTimer);
    _isRunning = true;
  }

  void _stopTimer() {
    _timer.cancel();
    _isRunning = false;
  }

  void _incTimer(Timer timer) {
    setState(() {
      _seconds = timer.tick;
    });
  }

  void _resetClock() {
    setState(() {
      _seconds = 0;
    });
  }

  void _longClick(int row, int column) async {
    _updateState(() => _engine.longClick(row, column));
  }

  void _click(int row, int column) async {
    _updateState(() => _engine.click(row, column));
  }

  void _newGame(int rows, int columns, int bombs) async {
    if (_isRunning) {
      _stopTimer();
    }
    _resetClock();
    _updateState(() => _engine.newGame(rows, columns, bombs));
  }

  void _updateState(Action action) async {
    GameState gameState = await action();
    if (!_isRunning && gameState.isRunning) _startTimer();
    if (_isRunning && !gameState.isRunning) _stopTimer();
    setState(() {
      _state = gameState.matrix;
      _flagsToSet = gameState.availableFlags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add_circle),
              onPressed: () {
                _newGame(13, 10, 15);
              })
        ],
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new RepaintBoundary.wrap(
                  new Counter(
                    value: _flagsToSet,
                  ),
                  0),
              new RepaintBoundary.wrap(
                  new Counter(
                    value: _seconds,
                  ),
                  1),
            ],
          ),
          new RepaintBoundary.wrap(
              new Center(
                child: new Board(
                  ids: _state,
                  size: MediaQuery.of(context).size.width,
                  onLongClick: _longClick,
                  onClick: _click,
                ),
              ),
              2)
        ],
      ),
    );
  }
}
