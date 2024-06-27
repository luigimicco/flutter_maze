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
        final x = cell.coords.x * cellWidth;
        final y = cell.coords.y * cellWidth;

        _drawCells(canvas, cell, x, y);
      }
    }
  }

  void _drawCells(Canvas canvas, Cell cell, double x, double y) {
    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(x, y, cellWidth + 0.5, cellWidth + 0.5),
      backgroundPaint,
    );
  }
}
