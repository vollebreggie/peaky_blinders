import 'package:flutter/material.dart';

class Drawhorizontalline extends CustomPainter {
  Paint _paint;
  double _size;

  Drawhorizontalline(double size) {
    _size = size;
    _paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-_size, 0.0), Offset(_size, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
