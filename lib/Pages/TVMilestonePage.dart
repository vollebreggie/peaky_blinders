import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Pages/TVCreateProjectTaskPage.dart';
import 'package:peaky_blinders/Pages/TVTaskPage.dart';
import 'package:peaky_blinders/widgets/task.dart';

class TVMilestonePage extends StatefulWidget {
  @override
  _TVMilestoneState createState() => _TVMilestoneState();
}

class _TVMilestoneState extends State<TVMilestonePage> {
  final titleController = TextEditingController();
  TVBloc tvBloc;
  Color titleColors = Colors.white70;

  MileStone selectedMilestone;

  _settitleValue() {
    if (titleController.text != "") {
      titleColors = Color.fromRGBO(47, 87, 53, 0.8);
    } else {
      titleColors = Colors.white70;
    }
    selectedMilestone.title = titleController.text;
    tvBloc.updateMilestoneToTv();
  }

  @override
  void initState() {
    super.initState();

    titleController.addListener(_settitleValue);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tvBloc = BlocProvider.of<TVBloc>(context);
    selectedMilestone = tvBloc.selectedMilestone;
    titleController.text = selectedMilestone.title;

    return new WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(60, 65, 74, 1),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: new Column(
                  children: [],
                ),
              ),
              tvBloc.selectedMilestone.tasks != null
                  ? Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: new DragAndDropList<ProjectTask>(
                        tvBloc.selectedMilestone.tasks,
                        itemBuilder: (BuildContext context, item) {
                          return new SizedBox(
                            child: InkWell(
                              child: createTask(context, item),
                              onTap: () async {
                                tvBloc.selectedMilestone.tasks
                                    .removeWhere((t) => t.id == item.id);
                                tvBloc.selectedProjectTask = item;
                                tvBloc.updateTaskToTv();
                                navigateToTVTaskPage(context);
                              },
                            ),
                          );
                        },
                        onDragFinish: (before, after) {
                          ProjectTask task =
                              tvBloc.selectedMilestone.tasks[before];
                          tvBloc.selectedMilestone.tasks.removeAt(before);
                          task.place = after;
                          tvBloc.selectedMilestone.tasks.insert(after, task);
                          tvBloc.updateTasksToTv();
                        },
                        canBeDraggedTo: (one, two) => true,
                        dragElevation: 8.0,
                      ),
                    )
                  : Container(),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  backgroundColor: Colors.transparent, //No more green
                  elevation: 0.0,
                  //Shadow gone
                ),
              ),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 7.0,
                left: 40.0,
                right: 0.0,
                child: TextField(
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  controller: titleController,
                  style: TextStyle(
                    // backgroundColor: Colors.transparent,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: "Milestone Title",
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
            child: const Icon(Icons.add),
            onPressed: () async {
              ProjectTask task = new ProjectTask(
                  id: 0, place: tvBloc.taskCounter,title: "New Task", points: 1, priority: "Trivial", milestoneId: 0, userId: tvBloc.owner.id, projectId: tvBloc.project.id);
              tvBloc.taskCounter++;
              tvBloc.selectedProjectTask = task;
              await navigateToTVCreateTaskPage(context);
            },
          ),
        ),
        onWillPop: navigateBack);
  }

  ListTile makeListTile(ProjectTask projectTask, BuildContext context) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 5),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 4.0, color: Colors.white24))),
          child: Text(
            projectTask.points.toString(),
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          projectTask.title,
          style: TextStyle(
              color: Colors.white, fontFamily: "Monsterrat", fontSize: 23),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: Row(
          children: <Widget>[],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          tvBloc.selectedMilestone.tasks
              .removeWhere((t) => t.id == projectTask.id);
          tvBloc.selectedProjectTask = projectTask;
          tvBloc.updateTaskToTv();
          navigateToTVTaskPage(context);
        },
      );

  Future navigateToTVTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TVTaskPage()));
  }

  Future navigateToTVCreateTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TVCreateTaskPage()));
  }

  Card makeCard(ProjectTask projectTask, BuildContext context) => Card(
        elevation: 8.0,
        color: Colors.transparent,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.black12,
                Colors.black12,
                Color.fromRGBO(0, 0, 0, 0.2),
                Color.fromRGBO(0, 0, 0, 0.2)
              ],
            ),
          ),
          child: makeListTile(projectTask, context),
        ),
      );

  Future<bool> navigateBack() async {
    MileStone milestone = new MileStone(tasks: []);
    tvBloc.selectedMilestone = milestone;
    tvBloc.updateMilestoneToTv();
    tvBloc.updateTasksToTv();
    tvBloc.selectedMilestone = null;

    return true;
  }
}
