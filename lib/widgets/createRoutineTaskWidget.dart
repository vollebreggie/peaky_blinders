import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';

Widget createRoutineTask(context, RoutineTaskSetting task) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 10,
          right: 5,
        ),
        height: 110,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(left: 50, top: 35),
          child: new Text(task.title.length < 17 ? task.title : task.title.substring(0, 17) + "..",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 25)),
          height: 70,
          //color: Colors.transparent,
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[900],
                blurRadius: 5.0, // has the effect of softening the shadow
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
        padding: EdgeInsets.only(left: 0.0, top: 10.0, right: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ClipPath(
            clipper: TrapeziumClipper(),
            child: Container(
              decoration: new BoxDecoration(
                  color: Color.fromRGBO(8, 68, 22, 1.0),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0))),
              //color: Color.fromRGBO(6, 32, 12, 1.0),
              //padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.25,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 25.0, right: 15),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                //maxHeight: 70,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4),
                            child: Center(
                              child: new Text("Points",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                // maxHeight: 70,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4),
                            child: Center(
                              child: new Text(task.points.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
