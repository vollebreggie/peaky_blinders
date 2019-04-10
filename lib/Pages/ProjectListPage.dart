import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';
import 'package:peaky_blinders/Pages/ProjectPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';

class ProjectListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(60, 65, 74, 1),
      body: Center(
        child: StreamBuilder<List<Project>>(
            stream: bloc.outProject,
            initialData: [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
              bloc.fetchProject.add(null);
              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeCard(snapshot.data[index], context);
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          navigateToSubPage(context);
        },
      ),
    );
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage()));
  }

  ListTile makeListTile(Project project, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 5),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Text(
            "209",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          "Project: Iron man",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  // tag: 'hero',
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: 0.2,
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Last updated: Today",
                      style: TextStyle(color: Colors.white, fontSize: 10.0))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {
          navigateToSubPage(context);
        },
      );

  Card makeCard(Project project, BuildContext context) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.1, color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        color: Colors.transparent,
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            image: new DecorationImage(
              image: new AssetImage("assets/ironman.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: makeListTile(project, context),
        ),
      );

  Future navigateToCreateTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateTaskPage(null)));
  }

  Future navigateToTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }
}
