import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/CreateProjectPage.dart';
import 'package:peaky_blinders/Pages/ProjectPage.dart';
import 'package:peaky_blinders/Pages/TVListPage.dart';
import 'package:peaky_blinders/Pages/TaskListPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';
import 'package:peaky_blinders/Pages/TasksTomorrowList.dart';
import 'package:peaky_blinders/widgets/NextTask.dart';
import 'package:peaky_blinders/widgets/TomorrowTasksWidget.dart';
import 'package:peaky_blinders/widgets/createPlanWidget.dart';
import 'package:peaky_blinders/widgets/dashboardStats.dart';
import 'package:peaky_blinders/widgets/taskWidget.dart';
import 'package:timeago/timeago.dart' as timeago;

class SynopsPage extends StatefulWidget {
  @override
  _SynopsPageState createState() => _SynopsPageState();
}

class _SynopsPageState extends State<SynopsPage> {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final PageBloc pageBloc = BlocProvider.of<PageBloc>(context);
    Task nextTask = taskBloc.getNextTask();

    Future navigateToPage(int index) async {
      pageBloc.page = index;
      await pageBloc.controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    Future changeNextTask() async {
      final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
      final SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
      final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

      await taskBloc.completedTask(taskBloc.getNextTask());
      await skillBloc.syncSkillByTask(taskBloc.getNextTask());
      await userBloc.getChartData();
      await userBloc.getCompletedTasksToday();
      await userBloc.getPointsGainedToday();
      await userBloc.getCompletedPoints();
      await userBloc.getCompletedTasks();
      await taskBloc.setNextTask();
      await taskBloc.setTasksForToday();
      setState(() {
        nextTask = taskBloc.getNextTask();
      });
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: Center(
        child: Column(
          children: <Widget>[
            InkWell(
              child: projectBloc.getProjectCount() == 0
                  ? InkWell(
                      child: createPlanWidget(context),
                      onTap: () {
                        _showDialog(context);
                      },
                    )
                  : nextTask != null
                      ? createNextTask(context, nextTask)
                      : InkWell(
                          child: createTomorrowTasksWidget(context),
                          onTap: () async {
                            await navigateToTomorrowTaskListPage(context);
                          },
                        ),
              onTap: () async {
                if (nextTask.runtimeType == ProjectTask) {
                  taskBloc.setProjectTask(nextTask);
                  await navigateToTaskPage(context);
                }
              },
              onLongPress: () async {
                await changeNextTask();
              },
            ),
            createStatistics(context),
            Row(
              children: <Widget>[
                InkWell(
                  child: createTask(
                      context,
                      "Tasks Left Today",
                      taskBloc.getTasksToday().length.toString(),
                      Icons.view_headline),
                  onTap: () async {
                    await navigateToPage(1);
                  },
                ),
                InkWell(
                  child: createTask(
                      context,
                      "Projects",
                      projectBloc.getProjectCount().toString(),
                      Icons.view_agenda),
                  onTap: () async {
                    await navigateToPage(2);
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                InkWell(
                  child: createTask(context, "Completed Tasks",
                      userBloc.completedTaskToday.toString(), Icons.check),
                ),
                InkWell(
                  child: createTask(context, "Points Gained",
                      userBloc.completedPointsToday.toString(), Icons.check),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToCreateProject(context) async {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
    bloc.selectedProblems = [];
    
    bloc.setCurrentProject(new Project(
        title: "ProjectName",
        description: "some description",
        imagePathServer: "example.jpg",
        totalPoints: 0,
        completedPoints: 0,
        priority: "Trivial",
        milestones: [],
        started: DateTime.now()));
    bloc.createMileStone();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  }

  Future navigateToProject(context, project) async {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
    bloc.setCurrentProject(project);

    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage()));
  }

  Future navigateToTaskListPage(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskListPage()));
  }

  Future navigateToTomorrowTaskListPage(context) async {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    await taskBloc.createTasksTomorrow();
    await taskBloc.setTasksForTomorrow();
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TasksTomorrowListPage()));
  }

  ListTile makeListTile(Project project, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 5),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Text(
            project.totalPoints.toString(),
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),

        title: Text(
          project.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                      "Last modified: " + timeago.format(project.lastUpdated),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10.0))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
          final TaskBloc blocTask = BlocProvider.of<TaskBloc>(context);
          bloc.setCurrentProject(project);
          blocTask.setProjectId(project.id);
          await navigateToProject(context, project);
        },
      );

  Card makeCard(Project project, BuildContext context) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          //side: BorderSide(width: 0.1, color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        color: Colors.transparent,
        child: Container(
          height: 175,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: new CachedNetworkImageProvider(
                  getImageFromProject(context, project.imagePathServer)),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: makeListTile(project, context),
                  )),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                    value: project.getProgress(),
                    valueColor: AlwaysStoppedAnimation(
                      Color.fromRGBO(47, 87, 53, 0.8),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  String getImageFromProject(context, image) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    return projectBloc.getImageFromServer(image);
  }

  Future navigateToTaskPage(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Create a plan by",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(47, 87, 53, 0.8),
              onPressed: () async {
                await navigateToCreateProject(context);
              },
              splashColor: Colors.grey,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: Container(
                //padding: const EdgeInsets.all(10.0),
                child: Text('Phone'),
              ),
            ),
            RaisedButton(
              color: Color.fromRGBO(47, 87, 53, 0.8),
              onPressed: () async {
                final TVBloc tvbloc = BlocProvider.of<TVBloc>(context);
                tvbloc.setOwner();

                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TVListPage()));
              },
              splashColor: Colors.grey,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: Container(
                //padding: const EdgeInsets.all(10.0),
                child: Text('TV'),
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
}
