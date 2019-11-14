import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';
import 'package:peaky_blinders/Pages/TaskPage.dart';
import 'package:peaky_blinders/widgets/task.dart';

class MilestonePage extends StatefulWidget {
  @override
  _MilestoneState createState() => _MilestoneState();
}

class _MilestoneState extends State<MilestonePage> {
  final titleController = TextEditingController();
  ProjectBloc projectBloc;
  TaskBloc taskBloc;
  MileStoneBloc mileStoneBloc;
  Color titleColors = Colors.white70;
  bool exit = true;
  MileStone selectedMilestone;

  _settitleValue() {
    if (titleController.text != "") {
      titleColors = Color.fromRGBO(47, 87, 53, 0.8);
    } else {
      titleColors = Colors.white70;
    }
    selectedMilestone.title = titleController.text;
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
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    mileStoneBloc = BlocProvider.of<MileStoneBloc>(context);
    taskBloc = BlocProvider.of<TaskBloc>(context);
    selectedMilestone = projectBloc.selectedMilestone;
    titleController.text = selectedMilestone.title;

    return new WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(44, 44, 44, 1),
          body: Stack(
            children: <Widget>[
              projectBloc.selectedMilestone.tasks != null
                  ? Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: new DragAndDropList<Task>(
                        projectBloc.selectedMilestone.tasks,
                        itemBuilder: (BuildContext context, item) {
                          return new SizedBox(
                            child: InkWell(
                              child: createTask(context, item),
                              onTap: () async {
                                taskBloc.setProjectTask(item);
                                taskBloc.selectedSkills = item.skills;
                                projectBloc.selectedMilestone.tasks
                                    .removeWhere((t) => t == item);
                                projectBloc.selectedProjectTask = item;
                                navigateToTaskPage(context);
                              },
                              onDoubleTap: () async {
                                _showDeleteDialog(context, item);
                              },
                            ),
                          );
                        },
                        onDragFinish: (before, after) {
                          ProjectTask task =
                              projectBloc.selectedMilestone.tasks[before];
                          projectBloc.selectedMilestone.tasks.removeAt(before);

                          projectBloc.selectedMilestone.tasks
                              .insert(after, task);
                        },
                        canBeDraggedTo: (one, two) => true,
                        dragElevation: 8.0,
                      ),
                    )
                  : Container(),
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  backgroundColor: Color.fromRGBO(44, 44, 44, 1), //No more green
                  elevation: 0.0,
                  //Shadow gone
                ),
              ),
              new Positioned(
                top: 40.0,
                left: 40.0,
                right: 0.0,
                child: Container(
                  color: Color.fromRGBO(44, 44, 44, 1),
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
                      fillColor: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
            child: const Icon(Icons.add),
            onPressed: () async {
              int milestoneCounter = 0;
              if (mileStoneBloc.milestones != null) {
                for (int i = 0; i < mileStoneBloc.milestones.length; i++) {
                  milestoneCounter += mileStoneBloc.milestones[i].tasks.length;
                }
              }
              UserBloc userBloc = BlocProvider.of<UserBloc>(context);
              ProjectTask task = new ProjectTask(
                  id: 0,
                  title: "New task",
                  description: "",
                  userId: userBloc.getUser().id,
                  milestoneId: mileStoneBloc.getCurrentMileStone().id,
                  place: milestoneCounter,
                  project: projectBloc.getCurrentProject(),
                  projectId: projectBloc.getCurrentProject().id,
                  points: 1,
                  priority: "Trivial");
              taskBloc.setProjectTask(task);
              taskBloc.skills = [];
              taskBloc.selectedSkills = [];
              await navigateToCreateTaskPage(context);
            },
          ),
        ),
        onWillPop: navigateBack);
  }

  void _showDeleteDialog(context, ProjectTask projectTask) {
    MileStoneBloc milestoneBloc = BlocProvider.of<MileStoneBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Project Task?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  projectBloc.selectedMilestone.tasks
                      .removeWhere((t) => t == projectTask);
                  if (projectTask.id != 0) {
                    taskBloc.deleteTaskAsync(projectTask);
                  }
                  setState(() {});
                  Navigator.of(context).pop();
                },
                splashColor: Colors.grey,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Container(
                  //margin: const EdgeInsets.all(10.0),
                  child: Text('Delete'),
                ),
              ),
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          projectBloc.selectedMilestone.tasks
              .removeWhere((t) => t.id == projectTask.id);
          projectBloc.selectedProjectTask = projectTask;
          navigateToTaskPage(context);
        },
      );

  Future navigateToTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }

  Future navigateToCreateTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateTaskPage()));
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
    if (exit) {
      exit = false;
      projectBloc.selectedMilestone = null;
      return true;
    }
    return false;
  }
}
