package com.yourcompany.flutterone;

import android.os.Bundle;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import de.devisnik.mine.*;

public class MainActivity extends FlutterActivity {

  IGame game;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    MethodChannel channel = new MethodChannel(getFlutterView(), "devisnik.de/mines");
    channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(final MethodCall methodCall, final MethodChannel.Result result) {
        if (methodCall.method.equals("start")) {
          int rows = methodCall.argument("rows");
          int columns = methodCall.argument("columns");
          int bombs = methodCall.argument("bombs");
          game = GameFactory.create(rows, columns, bombs);
          result.success(gameToState(game));
        }
        else if (methodCall.method.equals("click")) {
          int row = methodCall.argument("row");
          int column = methodCall.argument("column");
          Log.i("mines-native", "received click (" + row + "," + column + ")");
          game.onRequestFlag(game.getBoard().getField(row, column));
          result.success(gameToState(game));
        }
        else if (methodCall.method.equals("longclick")) {
          int row = methodCall.argument("row");
          int column = methodCall.argument("column");
          Log.i("mines-native", "received click (" + row + "," + column + ")");
          game.onRequestOpen(game.getBoard().getField(row, column));
          result.success(gameToState(game));
        }
        else {
          result.notImplemented();
        }
      }
    });
  }

  private Object gameToState(IGame game) {
    IBoard board = game.getBoard();
    Point size = board.getDimension();
    ArrayList<Object> state = new ArrayList<>();
    for (int row = 0; row < size.x; row++) {
      int[] line = new int[size.y];
      for(int column=0; column < size.y; column++) {
        line[column] = board.getField(row, column).getImage();
      }
      state.add(line);
    }
    HashMap<String, Object> map = new HashMap<>();
    map.put("board", state);
    map.put("running", game.isRunning());
    map.put("flags", game.getBombCount() - game.getBoard().getFlagCount());
    return map;
  }
}
