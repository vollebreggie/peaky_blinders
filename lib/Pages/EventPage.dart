import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Pages/chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EventPageState();
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class _EventPageState extends State<EventPage> {
 
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {

    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return new Scaffold(
        // resizeToAvoidBottomPadding: true,
        backgroundColor: Color.fromRGBO(60, 65, 74, 1),
        body: Container(
          // Add box decoration

          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.black38,
                Colors.black38,
                Colors.black45,
                Color.fromRGBO(0, 0, 0, 0.6),
              ],
            ),
          ),
          child: null
        ));
  }

  
}
