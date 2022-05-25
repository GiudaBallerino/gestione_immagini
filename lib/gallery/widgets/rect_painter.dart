import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RectPainter extends CustomPainter {
  List<Offset> points;
  bool clear;
  //ui.Image image;

  RectPainter({required this.points, required this.clear,});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    if (!clear) {
      for (int i = 0; i < points.length; i++) {
        if (i + 1 == points.length) {
          canvas.drawLine(Offset(size.width*(points[i].dx/100),size.height*(points[i].dy/100)), Offset(size.width*(points[0].dx/100),size.height*(points[0].dy/100)), paint);
        } else {
          canvas.drawLine(Offset(size.width*(points[i].dx/100),size.height*(points[i].dy/100)), Offset(size.width*(points[i+1].dx/100),size.height*(points[i+1].dy/100)), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(RectPainter oldPainter) =>
      oldPainter.points != points || clear;
}
