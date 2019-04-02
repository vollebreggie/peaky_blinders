import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectTaskBloc.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';
import 'package:peaky_blinders/Pages/Taskpage.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<ProjectPage> {
  List<String> _locations = [
    'Trivial',
    'Valuable',
    'Necessary',
    'Paramount'
  ]; // Option 2
  String _selectedLocation; // Option 2

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final ProjectTaskBloc taskBloc = BlocProvider.of<ProjectTaskBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(60, 65, 74, 1),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: Stack(children: <Widget>[
                new Image.asset(
                  "assets/splashscreen.png",
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                ),
                new Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 50, bottom: 20.0),
                    child: TextFormField(
                        initialValue: "Project: Iron man",
                        cursorColor: Colors.white,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Project Name',
                        ),
                        style:
                            new TextStyle(fontSize: 25.0, color: Colors.white)),
                  ),
                ),
                new Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: 0.2,
                        valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
                  ),
                )
              ]),
              backgroundColor: Colors.transparent,
            ),
          ];
        },
        body: Center(
          child: SingleChildScrollView(
            child: new Column(
              children: [
                Card(
                    color: Color.fromRGBO(60, 65, 74, 1),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            alignment: Alignment.centerLeft,
                            margin: new EdgeInsets.only(
                                top: 5.0, left: 15.0, bottom: 5),
                            child: new Container(
                              alignment: Alignment.centerLeft,
                              child: new Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Color.fromRGBO(60, 65, 74, 1),
                                  ),
                                  child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Container(
                                            alignment: Alignment.centerLeft,
                                            margin: new EdgeInsets.only(
                                                right: 15.0),
                                            child: Icon(Icons.low_priority,
                                                color: Colors.white70)),
                                        new DropdownButton(
                                          hint: Text('Priority',
                                              style: new TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0)),
                                          value: _selectedLocation,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedLocation = newValue;
                                            });
                                          },
                                          items: _locations.map((location) {
                                            return DropdownMenuItem(
                                              child: new Text(location,
                                                  style: new TextStyle(
                                                      color: Colors.white70)),
                                              value: location,
                                            );
                                          }).toList(),
                                        ),
                                      ])),
                            ),
                          ),
                          new Container(
                            margin: new EdgeInsets.only(
                                top: 10.0, right: 60, bottom: 5),
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                      alignment: Alignment.centerLeft,
                                      margin: new EdgeInsets.only(right: 5.0),
                                      child: Icon(Icons.show_chart,
                                          color: Colors.white70)),
                                  new Text(
                                    "Points: 43",
                                    style: new TextStyle(
                                        color: Colors.white70, fontSize: 15.0),
                                  ),
                                ]),
                          ),
                        ])),
                new Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Color.fromRGBO(60, 65, 74, 1),
                    child: new Column(children: [
                      Center(
                        child: Card(
                          color: Color.fromRGBO(60, 65, 74, 1),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.description,
                                    color: Colors.white70),
                                title: Text(
                                  'Description',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 0, top: 0),
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                //padding: EdgeInsets.all(10.0),
                                child: new ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 150.0,
                                  ),
                                  child: new Scrollbar(
                                    child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      reverse: true,
                                      child: SizedBox(
                                        height: 150.0,
                                        child: new TextField(
                                          cursorColor: Colors.white,
                                          textAlign: TextAlign.left,
                                          maxLines: 100,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.normal),
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
                StreamBuilder<List<ProjectTask>>(
                    stream: taskBloc.outProjectTask,
                    initialData: [],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ProjectTask>> snapshot) {
                      taskBloc.fetchProjectTask.add(null);
                      return Container(
                        color: Color.fromRGBO(60, 65, 74, 1),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return makeCard(snapshot.data[index], context);
                          },
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          saveProject(context, projectBloc);
        },
      ),
    );
  }

  void saveProject(BuildContext context, ProjectBloc bloc) {
    Project project = new Project(id: 1, title: "doei", description: "hallo");
    Repository.get().updateProject(project);
    bloc.fetchProject.add(null);
    navigateBack(context);
  }

  void makeNewTask(Project project, BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateTaskPage(project)));
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

  Future navigateBack(context) async {
    Navigator.pop(context, true);
  }

  Future navigateToTaskPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }
}
