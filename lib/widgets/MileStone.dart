import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Pages/MilestonePage.dart';
import 'package:peaky_blinders/Pages/TVMilestonePage.dart';
import 'package:peaky_blinders/widgets/SelectedUsers.dart';

import 'TrapeziumClipper.dart';

Widget createMileStoneTV(context, MileStone milestone) {
  return InkWell(
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5.0, top: 10, right: 5),
          height: 105,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Card(
            elevation: 8,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.only(left: 90.0),
              child: Center(
                  child: new Text(milestone.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              height: 120,
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
                width: MediaQuery.of(context).size.width * 0.3,
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 25.0, right: 15),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            //maxHeight: 70,
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Center(
                          child: new Text("Tasks",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            // maxHeight: 70,
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Center(
                          child: new Text(milestone.tasks != null ? milestone.tasks.length.toString() : "",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    ),
    onTap: () async {
      TVBloc tvBloc = BlocProvider.of<TVBloc>(context);
      tvBloc.selectedMilestone = milestone;
      tvBloc.updateTasksToTv();
      tvBloc.updateMilestoneToTv();
      await navigateToTVMilestonePage(context);
    },
  );
}

Widget createMileStone(context, MileStone milestone) {
  return InkWell(
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5.0, top: 10, right: 5),
          height: 105,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Card(
            elevation: 8,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.only(left: 90.0),
              child: Center(
                  child: new Text(milestone.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              height: 120,
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
                width: MediaQuery.of(context).size.width * 0.3,
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 25.0, right: 15),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            //maxHeight: 70,
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Center(
                          child: new Text("Tasks",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            // maxHeight: 70,
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: Center(
                          child: new Text(milestone.tasks != null ? milestone.tasks.length.toString() : "",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    ),
    onTap: () async {
      ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
      MileStoneBloc milestoneBloc = BlocProvider.of<MileStoneBloc>(context);
      projectBloc.selectedMilestone = milestone;
      milestoneBloc.setCurrentMileStone(milestone);
      await navigateToMilestonePage(context);
    },
  );
}


Future navigateToTVMilestonePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => TVMilestonePage()));
}

Future navigateToMilestonePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => MilestonePage()));
}
