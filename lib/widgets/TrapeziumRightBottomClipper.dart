import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TrapeziumRightBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width , size.height);
    path.lineTo(0.0 , size.height);
    path.lineTo(size.width * 0.25 , 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumRightBottomClipper oldClipper) => false;
}
