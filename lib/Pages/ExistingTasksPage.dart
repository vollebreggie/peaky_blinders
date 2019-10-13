import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';
import 'package:peaky_blinders/widgets/ExistingTaskWidget.dart';

class ExistingTaskListPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  ExistingTaskListState createState() => new ExistingTaskListState();
}

class ExistingTaskListState extends State<ExistingTaskListPage> {
  Widget _appBarTitle = new Text('Search Task..');
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          taskBloc.setSearchExistingTask(_searchText);
        });
      }
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
          centerTitle: true,
          title: InkWell(child: _appBarTitle, onTap: _searchPressed),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                    Navigator.pop(context, false),
                  })),
      body: StreamBuilder<List<Task>>(
        stream: taskBloc.outTask,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          taskBloc.getExistingTasksForToday();
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return createExistingTaskWidget(context, snapshot.data[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Future navigateToCreateTaskPage(context) async {
    final TaskBloc blocTask = BlocProvider.of<TaskBloc>(context);
    blocTask.setProjectTask(new ProjectTask(
        id: 0, title: "", description: "", priority: "Trivial", points: 1));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateTaskPage()));
  }

  void _searchPressed() {
    setState(() {
      if (this._appBarTitle.runtimeType == Text) {
        this._appBarTitle = new TextField(
          controller: _filter,
          style: new TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            border: InputBorder.none,
            filled: true,
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            hintText: 'Search...',
          ),
          cursorColor: Colors.white,
          autofocus: true,
        );
      } else {
        this._appBarTitle = new Text('Search Example');
        _filter.clear();
      }
    });
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
              onPressed: () {
                //navigate to creating a new task
                navigateToCreateTaskPage(context);
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
                //start existing tasks
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
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
