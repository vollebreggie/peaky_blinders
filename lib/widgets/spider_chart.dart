import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class SpiderChart extends StatelessWidget {
  final List<double> data;
  final List<String> skills;
  final double maxValue;
  final List<Color> colors;
  final decimalPrecision;
  final Size size;
  final double fallbackHeight;
  final double fallbackWidth;

  SpiderChart(
      {Key key,
      @required this.data,
      @required this.colors,
      @required this.maxValue,
      this.size = Size.infinite,
      this.decimalPrecision = 0,
      this.fallbackHeight = 200,
      this.fallbackWidth = 200,
      this.skills})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: fallbackWidth,
      maxHeight: fallbackHeight,
      child: CustomPaint(
        size: size,
        painter: SpiderChartPainter(
            data, maxValue, colors, decimalPrecision, skills),
      ),
    );
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<double> data;
  final double maxNumber;
  final List<Color> colors;
  final decimalPrecision;
  final List<String> skills;

  final Paint spokes = Paint()..color = Colors.grey;

  final Paint fill = Paint()
    ..color = Color.fromRGBO(8, 68, 22, 0.5) //Color.fromARGB(15, 50, 50, 50)
    ..style = PaintingStyle.fill;

  final Paint stroke = Paint()
    ..color = Color.fromRGBO(8, 68, 22, 1.0)
    ..style = PaintingStyle.stroke;

  SpiderChartPainter(this.data, this.maxNumber, this.colors,
      this.decimalPrecision, this.skills);

  @override
  void paint(Canvas canvas, Size size) {
    try {
      Offset center = size.center(Offset.zero);

      double angle = (2 * pi) / data.length;

      var points = List<Offset>();

      for (var i = 0; i < data.length; i++) {
        var scaledRadius = (data[i] / maxNumber) * center.dy;
        if(scaledRadius.isNaN) scaledRadius = 1.0;
        var x = scaledRadius * cos(angle * i - pi / 2);
        var y = scaledRadius * sin(angle * i - pi / 2);

        points.add(Offset(x, y) + center);
      }

      paintGraphOutline(canvas, center, angle);
      paintDataLines(canvas, points);
      paintDataPoints(canvas, points);
      paintText(canvas, center, points, data);
    } catch (ex) {
      print("hello");
    }
  }

  void paintDataLines(Canvas canvas, List<Offset> points) {
    Path path = Path()..addPolygon(points, true);

    canvas.drawPath(
      path,
      fill,
    );

    canvas.drawPath(path, stroke);
  }

  void paintDataPoints(Canvas canvas, List<Offset> points) {
    try {
      for (var i = 0; i < points.length; i++) {
        canvas.drawCircle(points[i], 4.0, Paint()..color = colors[i]);
      }
    } catch (ex) {
      print("2");
    }
  }

  void paintText(
      Canvas canvas, Offset center, List<Offset> points, List<double> data) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);

    try {
      for (var i = 0; i < points.length; i++) {
        String s = data[i].toStringAsFixed(decimalPrecision);
        textPainter.text = TextSpan(
            text: s, style: TextStyle(color: Colors.white54, fontSize: 10));
        textPainter.layout();
        if (points[i].dx < center.dx) {
          textPainter.paint(canvas,
              points[i].translate(-(textPainter.size.width + 5.0), -15));
        } else if (points[i].dx > center.dx) {
          textPainter.paint(canvas, points[i].translate(5.0, -15));
        } else if (points[i].dy < center.dy) {
          textPainter.paint(
              canvas, points[i].translate(-(textPainter.size.width / 2), 0));
        } else {
          textPainter.paint(
              canvas, points[i].translate(-(textPainter.size.width / 2), -10));
        }
      }
    } catch (ex) {
      print("3");
    }
  }

  void paintGraphOutline(Canvas canvas, Offset center, double angle) {
    try {
      var outline = List<Offset>();
      var textHeader = TextPainter(textDirection: TextDirection.ltr);
      if(data.length == 0) return;
      for (var i = 0; i < data.length; i++) {
        textHeader.text =
            TextSpan(text: skills[i], style: TextStyle(color: Colors.white70));
        textHeader.layout();
        var x = center.dy * cos(angle * i - pi / 2);
        var y = center.dy * sin(angle * i - pi / 2);
        Offset offset = Offset(x, y) + center;
        if (offset.dx < center.dx) {
          textHeader.paint(
              canvas, offset.translate(-(textHeader.size.width + 5.0), 0));
        } else if (offset.dx > center.dx) {
          textHeader.paint(canvas, offset.translate(5.0, 0));
        } else if (offset.dy < center.dy) {
          textHeader.paint(
              canvas, offset.translate(-(textHeader.size.width / 2), -20));
        } else {
          textHeader.paint(
              canvas, offset.translate(-(textHeader.size.width / 2), 4));
        }
        outline.add(Offset(x, y) + center);
        // textHeader.paint(canvas,
        //     Offset(x, y) + center.translate(-(textHeader.size.width / 2), 4));
        canvas.drawLine(center, outline[i], spokes);
      }

      outline.add(outline[0]);

      canvas.drawPoints(PointMode.polygon, outline, spokes);

      canvas.drawCircle(center, 2, spokes);
    } catch (ex) {
      print("lol");
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
