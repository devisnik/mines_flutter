import 'dart:async';

import 'package:flutter/services.dart';

class GameState {
  final List<List<int>> board;
  final int availableFlags;
  final bool isRunning;

  const GameState(this.board, this.availableFlags, this.isRunning);
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
  Future<GameState> newGame(int rows, int columns, int bombs) =>
      _invokeMethod("start", {
        "rows": rows,
        "columns": columns,
        "bombs": bombs,
      });

  @override
  Future<GameState> click(int row, int column) =>
      _invokeMethod("click", {
        "row": row,
        "column": column,
      });

  @override
  Future<GameState> longClick(int row, int column) =>
      _invokeMethod("longclick", {
        "row": row,
        "column": column,
      });

  _toState(Map map) => new GameState(
    map["board"],
    map["flags"],
    map["running"],
  );

  Future<GameState> _invokeMethod(String method, [dynamic arguments]) async =>
      _toState(await platform.invokeMethod(method, arguments));
}

class _FakeEngine implements Engine {
  List<List<int>> _board;

  @override
  Future<GameState> click(int row, int column) => new Future(() {
        _board[row][column] = _board[row][column] == 10 ? 0 : 10;
      }).then((_) => new GameState(_board, 10, true));

  @override
  Future<GameState> longClick(int row, int column) => click(row, column);

  @override
  Future<GameState> newGame(int rows, int columns, int bombs) => new Future(() {
        _board = new List<List<int>>.generate(
          rows,
          (_) => new List<int>.filled(columns, 10),
        );
      }).then((_) => new GameState(_board, 10, false));
}
