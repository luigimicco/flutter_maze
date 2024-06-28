import 'dart:ui';

import 'package:flutter/material.dart';

import 'cell.dart';
import 'coords.dart';

class Maze {
  // dimensione della griglia (ipotesi che sia quadrata)
  final double size;

  // dimensione singola cella
  final double cellWidth;

  Maze({
    required this.size,
    required this.cellWidth,
  }) {
    // griglia iniziale
    _createGrid();
  }

  // array delle celle
  final List<List<Cell>> grid = <List<Cell>>[];

  int get rows => (size / cellWidth).floor();
  int get columns => (size / cellWidth).floor();

  void _createGrid() {
    grid.clear();

    for (var i = 0; i < columns; i++) {
      grid.add(<Cell>[]);

      for (var j = 0; j < rows; j++) {
        grid[i].add(Cell(coords: Coords(i, j)));
      }
    }
  }

  void draw(Canvas canvas) {
    for (var i = 0; i < grid.first.length; i++) {
      for (var j = 0; j < grid.length; j++) {
        final cell = grid[j][i];

        _drawCell(canvas, cell);
      }
    }
  }

  void _drawCell(Canvas canvas, Cell cell) {
    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final x = cell.coords.x * cellWidth;
    final y = cell.coords.y * cellWidth;

    canvas.drawRect(
      Rect.fromLTWH(x, y, cellWidth + 0.5, cellWidth + 0.5),
      backgroundPaint,
    );
    _drawBorders(canvas, cell.borders, x, y);
  }

  void _drawBorders(Canvas canvas, List<Side> borders, double x, double y) {
    final borderPaint = Paint()..color = Colors.red;

    // border top
    if (borders.contains(Side.t)) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + cellWidth, y),
        borderPaint,
      );
    }

    // border right
    if (borders.contains(Side.r)) {
      canvas.drawLine(
        Offset(x + cellWidth, y),
        Offset(x + cellWidth, y + cellWidth),
        borderPaint,
      );
    }

    // border bottom
    if (borders.contains(Side.b)) {
      canvas.drawLine(
        Offset(x + cellWidth, y + cellWidth),
        Offset(x, y + cellWidth),
        borderPaint,
      );
    }

    // border left
    if (borders.contains(Side.l)) {
      canvas.drawLine(
        Offset(x, y + cellWidth),
        Offset(x, y),
        borderPaint,
      );
    }
  }
}
