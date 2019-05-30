import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Pages/CreateProjectPage.dart';
import 'package:peaky_blinders/Pages/ProjectPage.dart';
import 'package:peaky_blinders/Pages/TVListPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';
import 'package:peaky_blinders/widgets/projectWidget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProjectListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: Center(
        child: StreamBuilder<List<Project>>(
            stream: projectBloc.outProject,
            initialData: [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
              projectBloc.getProjects();
              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return createNextProject(context, snapshot.data[index]);
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
        child: const Icon(Icons.add),
        onPressed: () {
          _showDialog(context);
          //navigateToCreateProject(context);
        },
      ),
    );
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Create project?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color.fromRGBO(47, 87, 53, 0.8),
              onPressed: () {
                navigateToCreateProject(context);
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
              onPressed: () {
                final TVBloc tvbloc = BlocProvider.of<TVBloc>(context);
                tvbloc.setOwner();

                Navigator.push(context,
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

  Future navigateToCreateProject(context) async {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);
    bloc.setCurrentProject(new Project(
        title: "title",
        description: "some description",
        imagePathServer: "example.jpg",
        totalPoints: 0,
        completedPoints: 0,
        priority: "Trivial",
        milestones: [],
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
          final MileStoneBloc milestoneBloc =
              BlocProvider.of<MileStoneBloc>(context);
          final TaskBloc blocTask =
              BlocProvider.of<TaskBloc>(context);
          bloc.setCurrentProject(project);
          blocTask.setProjectId(project.id);
          milestoneBloc.getMilestonesByProjectId(project.id);
          navigateToProject(context, project);
        },
      );

  Card makeCard(Project project, BuildContext context) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
            //side: BorderSide(width: 0.1, color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
            child: Column(children: <Widget>[
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
                            Color.fromRGBO(47, 87, 53, 0.8))),
                  ))
            ])),
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
