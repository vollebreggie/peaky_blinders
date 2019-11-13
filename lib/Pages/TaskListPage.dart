import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/CreateTaskTodayPage.dart';
import 'package:peaky_blinders/Pages/ExistingTasksPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';
import 'package:peaky_blinders/widgets/task.dart';
import 'package:peaky_blinders/widgets/taskTodayWidget.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: new DragAndDropList<Task>(
        taskBloc.getTasksToday(),
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createTodayTask(context, item),
              onTap: () async {
                if (item.runtimeType == ProjectTask) {
                  taskBloc.setProjectTask(item);
                  taskBloc.getTasksToday().removeWhere((t) => t == item);
                  navigateToTaskPage(context);
                }
              },
              onDoubleTap: () async {
                if (item.runtimeType == ProjectTask) {
                  _showOptionsDialog(context, item);
                } else if (item.runtimeType == RoutineTask) {
                  _showDeleteDialog(context, item);
                }
              },
            ),
          );
        },
        onDragFinish: (before, after) async {
          await taskBloc.changePriorityOfTasksToday(before, after);
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
      floatingActionButton: projectBloc.getProjectCount() != 0
          ? FloatingActionButton(
              backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
              child: const Icon(Icons.add),
              onPressed: () {
                _showDialog(context);
              },
            )
          : null,
    );
  }

  Future navigateToCreateTaskTodayPage(context) async {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    //Project project = await projectBloc.getFirstProject();
    //if (project != null) {
    ProjectTask task = new ProjectTask(
        id: 0,
        title: "New task",
        description: "",
        userId: userBloc.getUser().id,
        // project: project,
        // projectId: project.id,
        //What project and which milestone
        //milestoneId: mileStoneBloc.getCurrentMileStone().id,
        //  milestoneId: project.milestones.first.id,
        //  place: project.milestones.first.tasks.length,
        points: 1,
        priority: "Trivial");
    taskBloc.setProjectTask(task);
    taskBloc.selectedSkills = [];
    taskBloc.skills = [];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTaskTodayPage()),
    );
    //}
  }

  void _showDialog(context) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Add Task To Today",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(47, 87, 53, 0.8),
              onPressed: () async {
                await navigateToCreateTaskTodayPage(context);
              },
              splashColor: Colors.grey,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: Container(
                //padding: const EdgeInsets.all(10.0),
                child: Text('New'),
              ),
            ),
            RaisedButton(
              color: Color.fromRGBO(47, 87, 53, 0.8),
              onPressed: () {
                navigateToExistingTaskPage(context);
              },
              splashColor: Colors.grey,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: Container(
                //padding: const EdgeInsets.all(10.0),
                child: Text('Existing'),
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

  Future navigateToTaskPage(context) async {
    TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage()))
        .then((value) {
      setState(() {
        taskBloc.getTasksToday();
      });
    });
  }

  Future navigateToExistingTaskPage(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExistingTaskListPage()));
  }

  void _showOptionsDialog(context, Task task) {
    TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Options Task",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 100.0,
              height: 40.0,
              child: RaisedButton(
                color: Color.fromRGBO(47, 87, 53, 0.8),
                onPressed: () async {
                  await taskBloc.setTaskNonActive(task);
                  await taskBloc.setTasksForToday();
                  await taskBloc.setNextTask();
                  setState(() {
                    //taskBloc.getTasksToday();
                  });
                  Navigator.of(context).pop();
                },
                splashColor: Colors.grey,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Container(
                  //margin: const EdgeInsets.all(10.0),
                  child: Text('Non-Active'),
                ),
              ),
            ),
            ButtonTheme(
              minWidth: 100.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  _showDeleteDialog(context, task);
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

  void _showDeleteDialog(context, Task task) {
    TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            task.runtimeType == ProjectTask ? "Are you sure?" : "Delete Task",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  await taskBloc.deleteTaskAsync(task);
                  await taskBloc.setTasksForToday();
                  await taskBloc.setNextTask();
                  setState(() {
                    //taskBloc.getTasksToday();
                  });
                  Navigator.of(context).pop();
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
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: projectTask.project.getProgress(),
                      valueColor: AlwaysStoppedAnimation(
                          Color.fromRGBO(47, 87, 53, 0.8))),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(projectTask.project.title,
                      style: TextStyle(color: Colors.white30, fontSize: 10))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          final TaskBloc bloc = BlocProvider.of<TaskBloc>(context);
          bloc.setProjectTask(projectTask);
          navigateToTaskPage(context);
        },
      );

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
}
