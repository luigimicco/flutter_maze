import 'package:flutter/material.dart';
import 'package:flutter_maze/logic/maze_painter.dart';

import 'logic/maze.dart';

void main() {
  runApp(MyApp());
}

const double size = 200;
const double cellWidth = 10;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Maze maze = Maze(
    size: size,
    cellWidth: cellWidth,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Maze demo'),
        ),
        body: Center(
          child: CustomPaint(
            size: const Size.square(size),
            painter: MazePainter(maze: maze),
          ),
        ),
      ),
    );
  }
}
