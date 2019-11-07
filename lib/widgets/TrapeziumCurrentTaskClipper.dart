import 'package:flutter/material.dart';

class TrapeziumProjectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width * 0.75 , size.height);
    path.lineTo(0.0 , size.height);
    path.lineTo(size.width * 0.25 , 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumProjectClipper oldClipper) => false;
}