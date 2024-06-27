import 'cell.dart';

class Maze {
  // dimensione della griglia (ipotesi che sia quadrata)
  final double size;

  // dimensione singola cella
  final double cellWidth;

  Maze({
    required this.size,
    required this.cellWidth,
  }) {}

  // array delle celle
  final List<List<Cell>> grid = <List<Cell>>[];

  int get rows => (size / cellWidth).floor();
  int get columns => (size / cellWidth).floor();
}
