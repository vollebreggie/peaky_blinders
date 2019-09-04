import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Pages/ProjectPage.dart';
import 'package:peaky_blinders/Pages/TVListPage.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';

Widget createNextProject(context, Project project) {
  final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
  return  Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: 5.0,
            top: 11,
            right: 5,
          ),
          height: 149,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 55),
            child: new Text(project.title,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 25)),
            height: 90,
            //color: Colors.transparent,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.fill,
                image: NetworkImage(
                    projectBloc.getImageFromServer(project.imagePathServer)),
              ),

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
                  color: Colors.grey[900],
                  borderRadius: new BorderRadius.only(
                    topRight: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.65,
                height: 140,
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
                                padding: EdgeInsets.only(top: 25.0, right: 15),
                                child: Center(
                                  child: new Text("Completed",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Center(
                                  child: new Text(
                                      project.completedPoints.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 25.0, right: 15),
                                child: Center(
                                  child: new Text("Total Points",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Center(
                                  child: new Text(
                                      project.totalPoints.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30)),
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
    );
}

Future navigateToProject(context, project) async {
  final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
  bloc.setCurrentProject(project);

  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProjectPage()));
}
