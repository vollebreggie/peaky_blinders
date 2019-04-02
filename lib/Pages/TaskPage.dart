import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<TaskPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<String> _priorities = ['Trivial', 'Valuable', 'Necessary', 'Paramount'];
  String _selectedPriority;
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  FocusNode _focusNode = FocusNode();
  List<String> _projects = [
    'PeakyBlinders',
    'IronMan',
  ];
  String _selectedProject; 

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: new Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Color.fromRGBO(60, 65, 74, 1),
                      ),
                      child: new DropdownButton(
                        hint: Text('Project',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 25.0)),
                        value: _selectedProject,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedProject = newValue;
                          });
                        },
                        items: _projects.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location,
                                style: new TextStyle(color: Colors.white)),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                new Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: 0.2,
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
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
                                          value: _selectedPriority,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedPriority = newValue;
                                            });
                                          },
                                          items: _priorities.map((location) {
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
                                  new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor:
                                          Color.fromRGBO(60, 65, 74, 1),
                                    ),
                                    child: new DropdownButton(
                                      hint: Text('Points',
                                          style: new TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15.0)),
                                      value: _selectedPoints,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedPoints = newValue;
                                        });
                                      },
                                      items: _points.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location,
                                              style: new TextStyle(
                                                  color: Colors.white70)),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ]),
                          ),
                        ])),
                Card(
                  color: Color.fromRGBO(60, 65, 74, 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.description, color: Colors.white70),
                        title: Text(
                          'Title',
                          style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        //padding: EdgeInsets.all(10.0),
                        child: new ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 40.0,
                          ),
                          child: new Scrollbar(
                            child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: SizedBox(
                                height: 40.0,
                                child: new TextField(
                                  cursorColor: Colors.white,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
        onPressed: () {
          SaveProjectTask(context);
        },
      ),
    );
  }

  void SaveProjectTask(BuildContext context) {
    ProjectTask task = new ProjectTask(
        id: 1,
        title: titleController.text,
        description: descriptionController.text,
        started: DateTime.now().toString(),
        completed: "null");
    //Repository.get().test();
    Repository.get().updateProjectTask(task);
    navigateBack(context);
  }

  Future navigateBack(context) async {
    Navigator.pop(context, true);
  }
}
