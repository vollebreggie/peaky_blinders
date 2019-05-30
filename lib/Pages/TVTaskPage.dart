import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TVTaskPage extends StatefulWidget {
  @override
  _TVTaskState createState() => _TVTaskState();
}

class _TVTaskState extends State<TVTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TVBloc tvBloc;
  Color priorityColors = Colors.white70;
  Color pointsColors = Colors.white70;
  Color titleColors = Colors.white70;
  Color descriptionsColors = Colors.white70;

  List<String> _priorities = ['Trivial', 'Valuable', 'Necessary', 'Paramount'];
  String _selectedPriority;
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  String image;
  ProjectTask tempProjectTask;

  _settitleValue() {
    if (titleController.text != "") {
      titleColors = Color.fromRGBO(47, 87, 53, 0.8);
    } else {
      titleColors = Colors.white70;
    }
    tempProjectTask.title = titleController.text;
  }

  _setDescriptionValue() {
    if (descriptionController.text != "") {
      descriptionsColors = Color.fromRGBO(47, 87, 53, 0.8);
    } else {
      descriptionsColors = Colors.white70;
    }

    tempProjectTask.description = descriptionController.text;
  }

  Color getPointsColor(int points) {
    if (points < 9) {
      return Color.fromRGBO(47, 87, 53, 0.8);
    }
    if (points > 9 && points < 30) {
      return Colors.orange;
    }
    if (points > 30) {
      return Colors.red;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "Valuable":
        {
          return Colors.yellow;
        }
        break;

      case "Trivial":
        {
          return Color.fromRGBO(47, 87, 53, 0.8);
        }
        break;

      case "Paramount":
        {
          return Colors.red;
        }
        break;

      case "Necessary":
        {
          return Colors.orange;
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    titleController.addListener(_settitleValue);
    descriptionController.addListener(_setDescriptionValue);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tvBloc = BlocProvider.of<TVBloc>(context);

    tempProjectTask = tvBloc.selectedProjectTask;
    titleController.text = tempProjectTask.title;
    descriptionController.text = tempProjectTask.description;
    pointsColors = getPointsColor(tempProjectTask.points);
    priorityColors = getPriorityColor(tempProjectTask.priority);
    _selectedPoints = tempProjectTask.points.toString();
    _selectedPriority = tempProjectTask.priority;
    image = null;

    return new WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(60, 65, 74, 1),
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.black26,
                Colors.black38,
                Colors.black45,
                Colors.black87,
              ],
            ),
          ),
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: Stack(children: <Widget>[
                    new CachedNetworkImage(
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: tvBloc.getImageFromProject(image),
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                    new Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: LinearProgressIndicator(
                            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                            value: 0,
                            valueColor: AlwaysStoppedAnimation(
                                Color.fromRGBO(47, 87, 53, 0.8))),
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
                      elevation: 25,
                      color: Colors.transparent,
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
                                      canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
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
                                                  color: priorityColors)),
                                          new DropdownButton(
                                            hint: Text('Priority',
                                                style: new TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15.0)),
                                            value: _selectedPriority,
                                            onChanged: (newValue) {
                                              setState(() {
                                                priorityColors =
                                                    getPriorityColor(newValue);
                                                tempProjectTask.priority =
                                                    newValue;
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
                                            color: pointsColors)),
                                    new Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            Color.fromRGBO(0, 0, 0, 0.8),
                                      ),
                                      child: new DropdownButton(
                                        hint: Text('Points',
                                            style: new TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15.0)),
                                        value: _selectedPoints,
                                        onChanged: (newValue) {
                                          setState(() {
                                            tempProjectTask.points =
                                                int.parse(newValue);
                                            pointsColors = getPointsColor(
                                                int.parse(newValue));
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
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 25,
                      color: Colors.transparent,
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading:
                                  Icon(Icons.description, color: titleColors),
                              title: TextField(
                                cursorColor: Colors.white,
                                textAlign: TextAlign.left,
                                controller: titleController,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      color: Colors.transparent,
                      child: new Column(
                        children: [
                          Center(
                            child: Card(
                              elevation: 25,
                              color: Colors.transparent,
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.description,
                                          color: descriptionsColors),
                                      title: Text(
                                        'Description',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 0, top: 0),
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
                                                controller:
                                                    descriptionController,
                                                cursorColor: Colors.white,
                                                textAlign: TextAlign.left,
                                                maxLines: 100,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.normal),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: navigateBack,
    );
  }

  Future<bool> navigateBack() async {
    tvBloc.selectedMilestone.tasks.add(tvBloc.selectedProjectTask);
    tvBloc.updateTasksToTv();
    ProjectTask task = new ProjectTask();
    tvBloc.selectedProjectTask = task;
    tvBloc.updateTaskToTv();
    tvBloc.selectedProjectTask = null;
    // Navigator.pop(context, true);
    return true;
  }
}
