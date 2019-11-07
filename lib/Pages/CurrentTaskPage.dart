import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/widgets/ClipShadowPart.dart';
import 'package:peaky_blinders/widgets/TrapeziumCurrentTaskClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumRightBottomClipper.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CurrentTaskPage extends StatefulWidget {
  @override
  _CurrentTaskPageState createState() => _CurrentTaskPageState();
}

class _CurrentTaskPageState extends State<CurrentTaskPage> {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    return Scaffold(
        backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: ClipShadowPath(
                clipper: WaveClipperTwo(),
                shadow: Shadow(blurRadius: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 55),
                  child: new Text("Project",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                  height: 90,
                  //color: Colors.transparent,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 10,
                        blurRadius: 5,
                        offset: Offset(0, 7), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          projectBloc.getImageFromServer("example.jpg")),
                    ),

                    color: Colors.grey[900],
                    borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(10.0),
                        topLeft: const Radius.circular(10.0)),
                    //color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15.0,
                top: MediaQuery.of(context).size.height * 0.300,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.elliptical(250, 90),
                          topRight: const Radius.elliptical(150, 50),
                          bottomRight: const Radius.elliptical(150, 40),
                          bottomLeft: const Radius.elliptical(0, 0)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 25.0, right: 15),
                                    child: Center(
                                      child: new Text("Completed",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Center(
                                      child: new Text("56",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30)),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 25.0, right: 15),
                                    child: Center(
                                      child: new Text("Total Points",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Center(
                                      child: new Text("45",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
