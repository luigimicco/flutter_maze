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
  // indice della casella iniziale
  final int start;
  // indice della casella finale
  final int end;

  Maze({
    required this.size,
    required this.cellWidth,
    required this.start,
    required this.end,
  }) {
    // griglia iniziale
    createGrid();
    createMaze();
  }

  // array delle celle
  final List<Cell> grid = <Cell>[];

  int get rows => (size / cellWidth).floor();
  int get columns => (size / cellWidth).floor();

  void createGrid() {
    grid.clear();

    for (var i = 0; i < rows * columns; i++) {
      final y = (i / columns).floor();
      final x = (i - y * columns).floor();

      grid.add(Cell(coords: Coords(x, y)));
    }
  }

  void draw(Canvas canvas) {
    for (var i = 0; i < grid.length; i++) {
      _drawCell(canvas, i);
    }
  }

  void drawPath(Canvas canvas) {
    // prendiamo solo le celle che fanno
    // parte del percroso
    final List<Cell> minPath = grid.where((Cell cell) => cell.isPath).toList();

    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cellWidth / 3;

    // per ogni cella, tracciamo una linea dal suo centro
    // al centro della cella che la precede nel percorso
    for (final cell in minPath) {
      double sX = cell.coords.x * cellWidth + cellWidth / 2;
      double sY = cell.coords.y * cellWidth + cellWidth / 2;

      if (cell.previous != null) {
        double eX = grid[cell.previous!].coords.x * cellWidth + cellWidth / 2;
        double eY = grid[cell.previous!].coords.y * cellWidth + cellWidth / 2;

        canvas.drawLine(Offset(sX, sY), Offset(eX, eY), paint);
      }
    }
  }

  void _drawCell(Canvas canvas, int cell) {
    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final x = grid[cell].coords.x * cellWidth;
    final y = grid[cell].coords.y * cellWidth;

    canvas.drawRect(
      Rect.fromLTWH(x, y, cellWidth + 0.5, cellWidth + 0.5),
      backgroundPaint,
    );

    // in corrispondenza delle caselle di inizio e fine,
    // inserisce un cerchietto bianco
    if (cell == start || cell == end) {
      canvas.drawCircle(
        Offset(x + cellWidth / 2, y + cellWidth / 2),
        cellWidth / 4,
        Paint()..color = Colors.white,
      );
    }

    _drawBorders(canvas, grid[cell].borders, x, y);
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

  // elenco delle celle adiacenti non ancora visitate
  List<int> _getAdjacents(int currentCell, {required bool checkBorders}) {
    final adjacents = <int>[];
    final List<Side> borders = <Side>[];

    final y = grid[currentCell].coords.y;
    final x = grid[currentCell].coords.x;

    if (y > 0) {
      borders.add(Side.t); // top
    }
    if (y < (rows - 1)) {
      borders.add(Side.b); // bottom
    }
    if (x > 0) {
      borders.add(Side.l); // left
    }
    if (x < (columns - 1)) {
      borders.add(Side.r); // right
    }

    for (final side in borders) {
      int adjacent = adjacentCell(currentCell, side);

      // se valuta i muri, verifica che non ce ne sia uno
      if (checkBorders && grid[currentCell].borders.contains(side)) {
        continue;
      }

      if (!grid[adjacent].visited) {
        adjacents.add(adjacent);
      }
    }

    return adjacents;
  }

  void createMaze() {
    final List<int> stack = <int>[];
    bool mazeComplete = false;

    int currentCell = 0; // cella alla posizione (0,0)
    grid[currentCell].visited = true;

    while (!mazeComplete) {
      final adjacents = _getAdjacents(currentCell, checkBorders: false);

      if (adjacents.isNotEmpty) {
        final nextCell = adjacents[Random().nextInt(adjacents.length)];

        stack.add(currentCell);
        _openBorders(currentCell, nextCell);

        currentCell = nextCell;
        grid[currentCell].visited = true;
      } else if (stack.isNotEmpty) {
        currentCell = stack.removeLast();
      } else {
        mazeComplete = true;
      }
    }

    final List<int> path = _findMinPath();
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

  List<int> _findMinPath() {
    List<int> result = <int>[];

    for (final cell in grid) {
      cell
        ..f = 0
        ..g = 0
        ..h = 0
        ..visited = false
        ..isPath = false
        ..previous = null;
    }

    final queue = <int>[start];

    while (queue.isNotEmpty) {
      // prende in esame la prima cella della coda
      var current = queue.first;

      // se esistem pate dalla cella
      // con il valore f minore
      for (final cell in queue) {
        if (grid[cell].f < grid[current].f) {
          current = cell;
        }
      }

      if (current == end) {
        // è stata raggiunta la casella finale
        grid[end]
          ..visited = true
          ..isPath = true;
        int node = end;
        List<int> path = <int>[node];

        // utilizziamo la proprità previous per ricostruire
        // il percorso a ritroso
        while (grid[node].previous != null) {
          node = grid[node].previous!;
          grid[node].isPath = true;
          path.add(node);
        }

        // il percorso è a ritroso, quindi invertiamo la lista
        result = path.reversed.toList();
        return result;
      }

      grid[current].visited = true;
      queue.remove(current);

      final adjacents = _getAdjacents(current, checkBorders: true);

      for (final cell in adjacents) {
        grid[cell].previous = current;
        grid[cell].g++;
        grid[cell]
          ..h = _getDistance(cell, end)
          ..f = grid[cell].g + grid[cell].h;

        if (!queue.contains(cell) && !grid[cell].visited) {
          queue.add(cell);
        }
      }
    }
    return result;
  }

  double _getDistance(int a, int b) {
    Coords cA = grid[a].coords;
    Coords cB = grid[b].coords;

    return sqrt(pow(cA.x - cB.x, 2) + pow(cA.y - cB.y, 2));
  }
}
