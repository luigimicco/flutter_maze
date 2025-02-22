import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maze/painter/maze_painter.dart';

import 'logic/maze.dart';

void main() {
  runApp(MyApp());
}

const double size = 400;
const double cellWidth = 30;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Maze maze = Maze(
    size: size,
    cellWidth: cellWidth,
    start: 0,
    end: pow((size / cellWidth).floor(), 2).floor() - 1,
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
        backgroundColor: Colors.black,
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
