import 'dart:async';

import 'package:flutter/services.dart';

class GameState {

  final List<List<int>> matrix;
  final int availableFlags;
  final bool isRunning;

  const GameState(this.matrix, this.availableFlags, this.isRunning);
}

abstract class Engine {

  factory Engine.native() => new _NativeEngine();
  factory Engine.fake() => new _FakeEngine();

  Future<GameState> newGame(int rows, int columns, int bombs);
  Future<GameState> click(int row, int column);
  Future<GameState> longClick(int row, int column);
}

class _NativeEngine implements Engine {

  static const platform = const MethodChannel('devisnik.de/mines');

  @override
  Future<GameState> newGame(int rows, int columns, int bombs) {
    return platform.invokeMethod("start", {
      "rows": rows,
      "columns": columns,
      "bombs": bombs
    }).then((map) => new GameState(map["board"], map["flags"], map["running"]));
  }

  @override
  Future<GameState> click(int row, int column) {
    return platform.invokeMethod("click", {
      "row": row,
      "column": column
    }).then((map) => new GameState(map["board"], map["flags"], map["running"]));
  }

  @override
  Future<GameState> longClick(int row, int column) {
    return platform.invokeMethod("longclick", {
      "row": row,
      "column": column
    }).then((map) => new GameState(map["board"], map["flags"], map["running"]));
  }
}

class _FakeEngine implements Engine {

  List<List<int>> _board;
  @override
  Future<GameState> click(int row, int column) {
    return new Future(() {
      _board[row][column] = _board[row][column] == 10 ? 0 : 10;
    }).then((whatever) => new GameState(_board, 10, true));
  }

  @override
  Future<GameState> longClick(int row, int column) {
    return click(row, column);
  }

  @override
  Future<GameState> newGame(int rows, int columns, int bombs) {
    return new Future(() {
      _board = new List<List<int>>(rows);
      for (var i = 0; i < rows; i++) {
        List<int> list = new List<int>(columns);
        for (var j = 0; j < columns; j++) {
          list[j] = 10;
        }
        _board[i] = list;
      }
    }).then((whatever) => new GameState(_board, 10, false));
  }

}
