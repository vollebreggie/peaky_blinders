import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectTaskBloc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';

class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectTaskBloc bloc = BlocProvider.of<ProjectTaskBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Center(
        child: StreamBuilder<List<ProjectTask>>(
            stream: bloc.outProjectTask,
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<ProjectTask>> snapshot) {
              bloc.fetchProjectTask.add(null);
              return Container(
                // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
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
        child: const Icon(Icons.add),
        onPressed: () {
          navigateToCreateTaskPage(context);
        },
      ),
    );
  }

  Future navigateToCreateTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateTaskPage(null)));
  }

  Future navigateToTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }

  ListTile makeListTile(ProjectTask projectTask, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 5),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Text(
            "12",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          "Title of a task.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                      value: 0.3,
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Project: Iron man",
                      style: TextStyle(color: Colors.white30))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {
          navigateToTaskPage(context);
        },
      );

  Card makeCard(ProjectTask projectTask, BuildContext context) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(66, 75, 94, 1)),
          child: makeListTile(projectTask, context),
        ),
      );
}
