import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TrapeziumLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.3, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumLeftClipper oldClipper) => false;
}
