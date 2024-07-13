import 'package:flutter/material.dart';

import '../logic/maze.dart';

class MazePainter extends CustomPainter {
  const MazePainter({required this.maze});

  final Maze maze;

  @override
  void paint(Canvas canvas, Size size) {
    maze
      ..draw(canvas)
      ..drawPath(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
