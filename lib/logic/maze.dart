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
}
