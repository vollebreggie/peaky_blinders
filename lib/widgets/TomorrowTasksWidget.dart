import 'package:flutter/material.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftBottomClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumRightBottomClipper.dart';

Widget createTomorrowTasksWidget(context) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 20,
          right: 10,
        ),
        height: 116,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(top: 36, right: 15),
          child: new Text("Set tasks for tomorrow",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          height: 98,
          //color: Colors.transparent,
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[900],
                blurRadius: 1.0, // has the effect of softening the shadow
                //spreadRadius: 5.0, // has the effect of extending the shadow
                offset: Offset(
                  4.0, // horizontal, move right 10
                  4.0, // vertical, move down 10
                ),
              ),
            ],
            color: Colors.grey[900],
            borderRadius: new BorderRadius.only(
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                topLeft: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0)),
            //color: Colors.transparent,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 5),
        child: Align(
          alignment: Alignment.topRight,
          child: ClipPath(
            clipper: TrapeziumRightBottomClipper(),
            child: Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(8, 68, 22, 1.0),
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(10.0),
                  bottomRight: const Radius.circular(10.0),
                ),
              ),
              //color: Color.fromRGBO(6, 32, 12, 1.0),
              //padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.23,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, top: 30),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          // maxHeight: 70,
                          maxWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Center(
                          child:
                              Icon(Icons.add, size: 40, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5),
        child: ClipPath(
          clipper: TrapeziumLeftBottomClipper(),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
              ),
            ),
            //color: Color.fromRGBO(6, 32, 12, 1.0),
            //padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.18,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30.0, right: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        //maxHeight: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.2),
                    child: Center(
                      child: Center(
                          child: Icon(Icons.view_headline,
                              size: 40, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}
