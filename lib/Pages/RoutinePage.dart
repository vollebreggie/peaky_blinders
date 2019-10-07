import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';
import 'package:peaky_blinders/widgets/selectedRoutineSettingSkillWidget.dart';
import 'package:peaky_blinders/widgets/selectedSkillWidget.dart';

class RoutinePage extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<RoutinePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RoutineSettingBloc routineBloc;
  RoutineTaskSetting tempRoutineTask;
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  Color pointsColors = Colors.white70;
  bool exit = true;

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
    descriptionController.addListener(_setDescriptionValue);
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
    routineBloc = BlocProvider.of<RoutineSettingBloc>(context);
    tempRoutineTask = routineBloc.getRoutineTask();
    titleController.text = tempRoutineTask.title;
    descriptionController.text = tempRoutineTask.description;
    pointsColors = getPointsColor(tempRoutineTask.points);
    _selectedPoints = tempRoutineTask.points.toString();

    Color monday = tempRoutineTask.monday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color tuesday = tempRoutineTask.tuesday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color wednesday = tempRoutineTask.wednesday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color thursday = tempRoutineTask.thursday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color friday = tempRoutineTask.friday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color saturday = tempRoutineTask.saturday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;
    Color sunday = tempRoutineTask.sunday == 1
        ? Color.fromRGBO(8, 68, 22, 1.0)
        : Colors.white;

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
                      height: MediaQuery.of(context).size.height * 0.8,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
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
                                                maxWidth: MediaQuery.of(context)
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
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, top: 10.0, right: 5),
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: new BorderRadius.only(
                                    topRight: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0),
                                    topLeft: const Radius.circular(20.0),
                                    bottomLeft: const Radius.circular(20.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.description,
                                          color: Colors.green),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 58,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 15),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                // maxHeight: 70,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3),
                                            child: Center(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Icon(Icons.description,
                                                    color: Colors.white,
                                                    size: 35),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 65,
                            child: StreamBuilder<List<Skill>>(
                                stream: routineBloc.outSkill,
                                initialData: [],
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Skill>> snapshot) {
                                  routineBloc.getSelectedSkill();
                                  return createSelectedRoutineTaskSettingSkills(
                                      context, snapshot.data);
                                }),
                          ),
                          Stack(
                            children: <Widget>[
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
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
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3),
                                            child: Center(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Icon(Icons.show_chart,
                                                    color: Colors.white,
                                                    size: 35),
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
                          Card(
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
            ],
          ),
        ),
        onWillPop: navigateBack);
  }

  Future<bool> navigateBack() async {
    if (exit) {
      exit = false;
      await routineBloc.updateRoutineTask(tempRoutineTask);
      await routineBloc.setRoutineSettings();
      return true;
    }
    return false;
  }
}
