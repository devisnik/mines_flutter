import 'dart:async';

import 'package:flutter/services.dart';

class GameState {

  final List<List<int>> matrix;
  final int availableFlags;
  final bool isRunning;

  const GameState(this.matrix, this.availableFlags, this.isRunning);
}

class NativeEngine {

  static const platform = const MethodChannel('devisnik.de/mines');

  Future<GameState> newGame(int rows, int columns, int bombs) async {
    Map newState = await platform.invokeMethod("start", {
      "rows": rows,
      "columns": columns,
      "bombs": bombs
    });
    return new GameState(newState["board"], newState["flags"], newState["running"]);
  }

  Future<GameState> click(int row, int column) async {
    Map newState = await platform.invokeMethod("click", {
      "row": row,
      "column": column
    });
    return new GameState(newState["board"], newState["flags"], newState["running"]);
  }

  Future<GameState> longClick(int row, int column) async {
    Map newState = await platform.invokeMethod("longclick", {
      "row": row,
      "column": column
    });
    return new GameState(newState["board"], newState["flags"], newState["running"]);
  }
}
