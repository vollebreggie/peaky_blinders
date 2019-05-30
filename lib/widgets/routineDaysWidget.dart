import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

Widget createRoutineDays(context, RoutineTaskSetting routineTaskSetting) {

  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 5.0, top: 10, right: 5),
        height: 70,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Card(
          elevation: 8,
          color: Colors.transparent,
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.only(left: 85.0),
            child: Row(
              children: <Widget>[
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child: new Text('Mon',
                        style: TextStyle(
                            color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Tue', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Wed', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Thu', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Fri', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Sat', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Center(
                  widthFactor: 0.48,
                  child: new FlatButton(
                    onPressed: () {},
                    child:
                        new Text('Sun', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            height: 70,
            //color: Colors.transparent,
            decoration: new BoxDecoration(
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
      ),
      Container(
          padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
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
              width: MediaQuery.of(context).size.width * 0.2,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          // maxHeight: 70,
                          maxWidth: MediaQuery.of(context).size.width * 0.3),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 15),
                          child:
                              Icon(Icons.repeat, color: Colors.white, size: 35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
    ],
  );
}
