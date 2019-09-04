import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumProjectClipper.dart';
import 'package:peaky_blinders/widgets/TrapeziumRightBottomClipper.dart';

Widget createTomorrowProjectTaskWidget(context, ProjectTask task) {
  ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
  bool loading = false;
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 10,
          right: 10,
        ),
        height: 106,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(top: 36, left: 120),
          child: new Text(
              task.title.length < 25
                  ? task.title
                  : task.title.substring(0, 23) + "..",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 18)),
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
        padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 5),
        child: Align(
          alignment: Alignment.topRight,
          child: ClipPath(
            clipper: TrapeziumRightBottomClipper(),
            child: Container(
              decoration: new BoxDecoration(
                color: task.runtimeType == ProjectTask
                    ? Color.fromRGBO(8, 68, 22, 1.0)
                    : Colors.transparent,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(10.0),
                  bottomRight: const Radius.circular(10.0),
                ),
              ),
              //color: Color.fromRGBO(6, 32, 12, 1.0),
              //padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.15,
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
                          child: task.runtimeType == ProjectTask
                              ? Icon(
                                  task.started != null
                                      ? Icons.remove
                                      : Icons.add,
                                  size: 40,
                                  color: Colors.white)
                              : Container()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.16,
        padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
        child: ClipPath(
          clipper: TrapeziumClipper(),
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 55),
            // child: new Text(project.title,
            //     textAlign: TextAlign.left,
            //     style: TextStyle(color: Colors.white, fontSize: 25)),
            height: 95,
            //color: Colors.transparent,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.fill,
                image: NetworkImage(projectBloc.getImageFromServer(task.project.imagePathServer)
                    ),
              ),
              color: Colors.grey[900],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
              ),
              //color: Colors.transparent,
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 40.0, top: 10.0, right: 5),
        child: ClipPath(
          clipper: TrapeziumProjectClipper(),
          child: Container(
            decoration: new BoxDecoration(
              color: task.started == null
                  ? Colors.grey[900]
                  : Color.fromRGBO(8, 68, 22, 1.0),
            ),
            //color: Color.fromRGBO(6, 32, 12, 1.0),
            //padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.18,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        //maxHeight: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.4),
                    child: Center(
                      child: new Text("Points",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        // maxHeight: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.4),
                    child: Center(
                      child: new Text(task.points.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        //maxHeight: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.2),
                    child: Center(
                      child: Center(
                        child: loading
                            ? CircularProgressIndicator()
                            : Icon(Icons.view_headline,
                                size: 30, color: Colors.white),
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
