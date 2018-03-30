import 'package:flutter/material.dart';

class _Tile extends StatelessWidget {
  final int id;
  final double size;
  final VoidCallback onClick;
  final VoidCallback onLongClick;

  const _Tile({this.id, this.size, this.onClick, this.onLongClick});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onClick,
      onLongPress: onLongClick,
      child: new Image.asset(
        "assets/images/classic_image_${id < 10 ? "0$id" : "$id"}.png",
        width: size,
        height: size,
        gaplessPlayback: true, //to avoid image flickering
      ),
    );
  }
}

typedef void ColumnCallback(int);

class _TileRow extends StatelessWidget {
  final List<int> ids;
  final double width;
  final ColumnCallback onClick;
  final ColumnCallback onLongClick;

  const _TileRow({this.ids, this.width, this.onClick, this.onLongClick});

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: ids
            .asMap()
            .map(
              (index, id) => new MapEntry(
                    index,
                    new _Tile(
                      id: id,
                      size: width / ids.length,
                      onClick: () => onClick(index),
                      onLongClick: () => onLongClick(index),
                    ),
                  ),
            )
            .values
            .toList(growable: false));
  }
}

typedef void RowColumnCallback(int row, int column);

class Board extends StatelessWidget {
  final List<List<int>> ids;
  final double size;
  final RowColumnCallback onClick;
  final RowColumnCallback onLongClick;

  const Board({this.ids, this.size, this.onClick, this.onLongClick});

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: ids
          .asMap()
          .map(
            (rowIndex, values) => new MapEntry(
                  rowIndex,
                  new _TileRow(
                    ids: values,
                    width: size,
                    onClick: (columnIndex) => onClick(rowIndex, columnIndex),
                    onLongClick: (columnIndex) =>
                        onLongClick(rowIndex, columnIndex),
                  ),
                ),
          )
          .values
          .toList(growable: false),
    );
  }
}
