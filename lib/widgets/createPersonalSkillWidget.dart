import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

Widget createPersonalSkillWidget(context, Skill skill) {
  return Stack(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 5),
        decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: new BorderRadius.only(
            topRight: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
            topLeft: const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.description, color: Colors.green),
              title: Text(
                skill.title,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: 20),
              ),
            ),
          ],
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
            height: 56,
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
                        child: Icon(
                          Icons.build,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
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
