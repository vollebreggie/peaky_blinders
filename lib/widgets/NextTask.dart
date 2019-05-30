import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';

Widget createNextTask(context, Task task) {
  return  Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: 5.0,
            top: 10,
            right: 5,
          ),
          height: 116,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(left: 15, top: 40),
            child: new Text(task.title,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 20)),
            height: 98,
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
          padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 5),
          child: Align(
            alignment: Alignment.topRight,
            child: ClipPath(
              clipper: TrapeziumLeftClipper(),
              child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(8, 68, 22, 1.0),
                    borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(10.0),
                        bottomRight: const Radius.circular(10.0))),
                //color: Color.fromRGBO(6, 32, 12, 1.0),
                //padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.35,
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 35),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            // maxHeight: 70,
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Center(
                            child: Icon(Icons.check,
                                size: 40, color: Colors.white)),
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
