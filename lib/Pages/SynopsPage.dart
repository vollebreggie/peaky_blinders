import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/CreateProjectPage.dart';
import 'package:peaky_blinders/Pages/ProjectPage.dart';
import 'package:peaky_blinders/Pages/TaskListPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';
import 'package:peaky_blinders/Pages/TasksTomorrowList.dart';
import 'package:peaky_blinders/widgets/NextTask.dart';
import 'package:peaky_blinders/widgets/TomorrowTasksWidget.dart';
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
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final PageBloc pageBloc = BlocProvider.of<PageBloc>(context);
    Task nextTask = taskBloc.getNextTask();

    void navigateToPage(int index) {
      pageBloc.page = index;
      pageBloc.controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    void changeNextTask() async {
      final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
      final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
      await taskBloc.completedTask(taskBloc.getNextTask());
      userBloc.getChartData();
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
            //TODO:: what to show when no task is available
            InkWell(
              child: nextTask != null
                  ? createNextTask(context, nextTask)
                  : InkWell(
                      child: createTomorrowTasksWidget(context),
                      onTap: () async {
                        navigateToTomorrowTaskListPage(context);
                      },
                    ),
              onTap: () async {
                if (nextTask.runtimeType == ProjectTask) {
                  taskBloc.setProjectTask(nextTask);
                  await navigateToTaskPage(context);
                }
              },
              onLongPress: () async {
                changeNextTask();
              },
            ),
            createStatistics(context),
            Row(
              children: <Widget>[
                InkWell(
                  child: createTask(
                      context,
                      "Tasks Today",
                      taskBloc.getTasksToday().length.toString(),
                      Icons.view_headline),
                  onTap: () {
                    navigateToPage(1);
                  },
                ),
                InkWell(
                  child: createTask(
                      context,
                      "Projects",
                      projectBloc.getProjectCount().toString(),
                      Icons.view_agenda),
                  onTap: () {
                    navigateToPage(2);
                  },
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
    bloc.setCurrentProject(new Project(
        id: 0,
        title: "title",
        description: "some description",
        imagePathServer: "example.jpg",
        totalPoints: 0,
        completedPoints: 0,
        priority: "Trivial",
        started: DateTime.now()));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  }

  Future navigateToProject(context, project) async {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
    bloc.setCurrentProject(project);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage()));
  }

  Future navigateToTaskListPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskListPage()));
  }

  Future navigateToTomorrowTaskListPage(context) async {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    await taskBloc.createTasksTomorrow(userBloc.getUser().id);
    await taskBloc.setTasksForTomorrow();
    Navigator.push(context,
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
        onTap: () {
          final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
          final TaskBloc blocTask = BlocProvider.of<TaskBloc>(context);
          bloc.setCurrentProject(project);
          blocTask.setProjectId(project.id);
          navigateToProject(context, project);
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }
}
