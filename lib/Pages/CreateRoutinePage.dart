import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

class CreateRoutinePage extends StatefulWidget {
  @override
  _CreateRoutineState createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutinePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RoutineSettingBloc taskBloc;
  RoutineTaskSetting tempRoutineTask;
  Color monday = Colors.white;
  Color tuesday = Colors.white;
  Color wednesday = Colors.white;
  Color thursday = Colors.white;
  Color friday = Colors.white;
  Color saturday = Colors.white;
  Color sunday = Colors.white;
  Color pointsColors = Colors.white70;
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;

  _settitleValue() {
    tempRoutineTask.title = titleController.text;
  }

  _setDescriptionValue() {
    tempRoutineTask.description = descriptionController.text;
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(_settitleValue);
    titleController.addListener(_setDescriptionValue);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Color getPointsColor(int points) {
    if (points < 9) {
      return Colors.green;
    }
    if (points > 9 && points < 30) {
      return Colors.orange;
    }
    if (points > 30) {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    taskBloc = BlocProvider.of<RoutineSettingBloc>(context);
    tempRoutineTask = taskBloc.getRoutineTask();
    _selectedPoints = tempRoutineTask.points.toString();
    pointsColors = getPointsColor(tempRoutineTask.points);

    return new WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(60, 65, 74, 1),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: new Column(
                  children: [
                    new Container(
                      padding: EdgeInsets.only(top: 50),
                      height: MediaQuery.of(context).size.height * 0.6,
                      color: Colors.transparent,
                      child: new Column(
                        children: [
                          Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5.0, top: 10, right: 5),
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Card(
                                  elevation: 8,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.zero,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 85.0),
                                    child: Row(
                                      children: <Widget>[
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.monday ==
                                                    0) {
                                                  tempRoutineTask.monday = 1;
                                                  monday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  monday = Colors.white;
                                                  tempRoutineTask.monday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Mon',
                                                style:
                                                    TextStyle(color: monday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.tuesday ==
                                                    0) {
                                                  tempRoutineTask.tuesday = 1;
                                                  tuesday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  tuesday = Colors.white;
                                                  tempRoutineTask.tuesday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Tue',
                                                style:
                                                    TextStyle(color: tuesday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.wednesday ==
                                                    0) {
                                                  tempRoutineTask.wednesday = 1;
                                                  wednesday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  wednesday = Colors.white;
                                                  tempRoutineTask.wednesday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Wed',
                                                style: TextStyle(
                                                    color: wednesday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.thursday ==
                                                    0) {
                                                  tempRoutineTask.thursday = 1;
                                                  thursday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  thursday = Colors.white;
                                                  tempRoutineTask.thursday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Thu',
                                                style:
                                                    TextStyle(color: thursday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.friday ==
                                                    0) {
                                                  tempRoutineTask.friday = 1;
                                                  friday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  friday = Colors.white;
                                                  tempRoutineTask.friday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Fri',
                                                style:
                                                    TextStyle(color: friday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.saturday ==
                                                    0) {
                                                  tempRoutineTask.saturday = 1;
                                                  saturday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  saturday = Colors.white;
                                                  tempRoutineTask.saturday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Sat',
                                                style:
                                                    TextStyle(color: saturday)),
                                          ),
                                        ),
                                        Center(
                                          widthFactor: 0.48,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                if (tempRoutineTask.sunday ==
                                                    0) {
                                                  tempRoutineTask.sunday = 1;
                                                  sunday = Color.fromRGBO(
                                                      8, 68, 22, 1.0);
                                                } else {
                                                  sunday = Colors.white;
                                                  tempRoutineTask.sunday = 0;
                                                }
                                              });
                                            },
                                            child: new Text('Sun',
                                                style:
                                                    TextStyle(color: sunday)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 70,
                                    //color: Colors.transparent,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: new BorderRadius.only(
                                          topRight: const Radius.circular(10.0),
                                          bottomRight:
                                              const Radius.circular(10.0),
                                          topLeft: const Radius.circular(20.0),
                                          bottomLeft:
                                              const Radius.circular(20.0)),
                                      //color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 5.0, top: 10.0, right: 5),
                                  child: ClipPath(
                                    clipper: TrapeziumClipper(),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                          color: Color.fromRGBO(8, 68, 22, 1.0),
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(10.0),
                                              bottomLeft:
                                                  const Radius.circular(10.0))),
                                      //color: Color.fromRGBO(6, 32, 12, 1.0),
                                      //padding: EdgeInsets.all(8.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(right: 15),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  // maxHeight: 70,
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.3),
                                              child: Center(
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Icon(Icons.repeat,
                                                      color: Colors.white,
                                                      size: 35),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          new Container(
                            alignment: Alignment.topCenter,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            //color: Colors.grey[900],
                            decoration: new BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            margin: new EdgeInsets.only(
                                top: 10.0, left: 5, right: 5, bottom: 5),
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                      alignment: Alignment.centerLeft,
                                      margin: new EdgeInsets.only(
                                          left: 20,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6),
                                      child: Icon(Icons.show_chart,
                                          color: pointsColors)),
                                  new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                    child: new DropdownButton(
                                      hint: Text('Points',
                                          style: new TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15.0)),
                                      value: _selectedPoints,
                                      onChanged: (newValue) {
                                        setState(() {
                                          tempRoutineTask.points =
                                              int.parse(newValue);
                                          pointsColors = getPointsColor(
                                              int.parse(newValue));
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
                          Center(
                            child: Card(
                              elevation: 1,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 0, top: 0),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    //padding: EdgeInsets.all(10.0),
                                    child: new ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 200.0,
                                      ),
                                      child: new Scrollbar(
                                        child: new SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          reverse: true,
                                          child: SizedBox(
                                            height: 200.0,
                                            child: new TextField(
                                              controller: descriptionController,
                                              cursorColor: Colors.white,
                                              textAlign: TextAlign.left,
                                              maxLines: 100,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Description'),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  backgroundColor: Colors.transparent, //No more green
                  elevation: 0.0,
                  //Shadow gone
                ),
              ),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 7.0,
                left: 40.0,
                right: 0.0,
                child: TextField(
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  controller: titleController,
                  style: TextStyle(
                    // backgroundColor: Colors.transparent,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: "Routine Task Title",
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
            heroTag: null,
            child: const Icon(Icons.save),
            onPressed: () async {
              await taskBloc.saveRoutineTask(tempRoutineTask);
              await taskBloc.setRoutineSettings();
              Navigator.pop(context);
            },
          ),
        ),
        onWillPop: navigateBack);
  }

  Future<bool> navigateBack() async {
    return true;
  }
}
