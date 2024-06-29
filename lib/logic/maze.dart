import 'dart:math';
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

    createMaze();
  }

  // array delle celle
  final List<Cell> grid = <Cell>[];
  final List<int> _stack = <int>[];
  bool _mazeComplete = false;

  int get rows => (size / cellWidth).floor();
  int get columns => (size / cellWidth).floor();

  void _createGrid() {
    grid.clear();

    for (var i = 0; i < rows * columns; i++) {
      final y = (i / columns).floor();
      final x = (i - y * columns).floor();

      grid.add(Cell(coords: Coords(x, y)));
    }
  }

  void draw(Canvas canvas) {
    for (var i = 0; i < grid.length; i++) {
      final cell = grid[i];
      _drawCell(canvas, cell);
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
    final borderPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

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

  int adjacentCell(int index, Side side) {
    int result = -1;

    if (side == Side.t) {
      result = index - columns;
    } else if (side == Side.b) {
      result = index + columns;
    } else if (side == Side.l) {
      result = index - 1;
    } else if (side == Side.r) {
      result = index + 1;
    }

    return result;
  }

  // eleco delle celle adiacenti non ancora visitate
  List<int> _getNeighbors(int currentCell, {required bool checkWalls}) {
    final neighbors = <int>[];
    final List<Side> borders = <Side>[];

    final y = grid[currentCell].coords.y;
    final x = grid[currentCell].coords.x;

    if (y > 0) {
      borders.add(Side.t); // neighbors.add(currentCell - columns); // top
    }
    if (y < (rows - 1)) {
      borders.add(Side.b); //  neighbors.add(currentCell + columns); // bottom
    }
    if (x > 0) {
      borders.add(Side.l); // neighbors.add(currentCell - 1); // left
    }
    if (x < (columns - 1)) {
      borders.add(Side.r); //  neighbors.add(currentCell + 1); // right
    }

    for (final border in borders) {
      if (checkWalls && grid[currentCell].borders.contains(border)) {
        continue;
      }

      int adjacent = adjacentCell(currentCell, border);

      if (!grid[adjacent].visited) {
        neighbors.add(adjacent);
      }
    }

    return neighbors;
  }

  void createMaze() {
    int currentCell = 0; // cella alla posizione (0,0)
    grid[currentCell].visited = true;

    while (!_mazeComplete) {
      final neighbors = _getNeighbors(
        currentCell,
        checkWalls: false,
      );

      if (neighbors.isNotEmpty) {
        final nextCell = neighbors[Random().nextInt(neighbors.length)];

        _stack.add(currentCell);
        _openBorders(currentCell, nextCell);

        currentCell = nextCell;
        grid[currentCell].visited = true;
      } else if (_stack.isNotEmpty) {
        currentCell = _stack.removeLast();
      } else {
        currentCell = -1;
        _mazeComplete = true;
      }
    }
  }

  void _openBorders(int currentCell, int nextCell) {
    final x = grid[currentCell].coords.x - grid[nextCell].coords.x;
    final y = grid[currentCell].coords.y - grid[nextCell].coords.y;

    if (x == 1) {
      grid[currentCell].borders.remove(Side.l);
      grid[nextCell].borders.remove(Side.r);
    } else if (x == -1) {
      grid[currentCell].borders.remove(Side.r);
      grid[nextCell].borders.remove(Side.l);
    }

    if (y == 1) {
      grid[currentCell].borders.remove(Side.t);
      grid[nextCell].borders.remove(Side.b);
    } else if (y == -1) {
      grid[currentCell].borders.remove(Side.b);
      grid[nextCell].borders.remove(Side.t);
    }
  }
}
