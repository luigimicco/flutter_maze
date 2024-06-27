import 'coords.dart';

// posizione dei bordi
enum Side { t, r, b, l } // top, bottom, left, right

class Cell {
  Cell({
    required this.coords,
  });

  final Coords coords;

  // ogni cella nasce con i bordi su tutti i lati
  final List<Side> borders = <Side>[
    Side.t,
    Side.r,
    Side.b,
    Side.l,
  ];
}
