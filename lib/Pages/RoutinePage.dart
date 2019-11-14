import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/MileStoneDropdown.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';
import 'package:peaky_blinders/widgets/ClipShadowPart.dart';
import 'package:peaky_blinders/widgets/DrawHorizontalLine.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  ProjectDropdown _selectedProject;
  MileStoneDropdown _selectedMileStone;
  String _image;
  RoutineSettingBloc _routineBloc;
  RoutineTaskSetting _routine;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  TaskBloc _taskBloc;
  bool exit = true;
  ProjectBloc _projectBloc;
  int _selectionTitle = 0;
  int _selectionDescription = 0;

  _settitleValue() {
    _routine.title = _titleController.text;
  }

  _setDescriptionValue() {
    _routine.description = _descriptionController.text;
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_settitleValue);
    _descriptionController.addListener(_setDescriptionValue);

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 600),
              curve: Curves.ease);
        } else {
          _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: Duration(milliseconds: 600),
              curve: Curves.ease);
        }
        _selectionTitle = _titleController.selection.baseOffset;
        _selectionDescription = _descriptionController.selection.baseOffset;
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    _projectBloc = BlocProvider.of<ProjectBloc>(context);
    final MileStoneBloc milestoneBloc = BlocProvider.of<MileStoneBloc>(context);
    SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light;
    _routineBloc = BlocProvider.of<RoutineSettingBloc>(context);
    _routine = _routineBloc.getRoutineTask();

    Color monday = _routine.monday == 1 ? Colors.white : Colors.white38;
    Color tuesday = _routine.tuesday == 1 ? Colors.white : Colors.white38;
    Color wednesday = _routine.wednesday == 1 ? Colors.white : Colors.white38;
    Color thursday = _routine.thursday == 1 ? Colors.white : Colors.white38;
    Color friday = _routine.friday == 1 ? Colors.white : Colors.white38;
    Color saturday = _routine.saturday == 1 ? Colors.white : Colors.white38;
    Color sunday = _routine.sunday == 1 ? Colors.white : Colors.white38;

    if (_routine != null) {
      _selectedPoints = _routine.points.toString();
      _titleController.text = _routine.title;
      _descriptionController.text = _routine.description;
      _titleController.selection =
          TextSelection.collapsed(offset: _selectionTitle);
      _descriptionController.selection =
          TextSelection.collapsed(offset: _selectionDescription);
    }
    setState(() {
      _currentStyle = SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromRGBO(44, 44, 44, 1),
      );
    });

    return AnnotatedRegion(
      value: _currentStyle,
      child: new WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(44, 44, 44, 1),
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: false,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: ClipShadowPath(
                          clipper: WaveClipperTwo(),
                          shadow: Shadow(blurRadius: 20),
                          child: Container(
                            child: new CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: _taskBloc.getImageFromProject(_image),
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ];
            },
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(-0.8, -0.95),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      maxLines: 1,
                      controller: _titleController,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your task here.",
                        labelText: 'Task',
                        focusColor: Colors.white,
                        suffixStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.65, 0.3),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 10,
                      cursorColor: Colors.white70,
                      style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.normal,
                          fontSize: 13),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your description here.",
                        labelText: 'Description',
                        focusColor: Colors.white,
                        suffixStyle: TextStyle(color: Colors.white),
                        helperStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-1.03, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.monday == 0) {
                          _routine.monday = 1;
                          monday = Colors.white;
                        } else {
                          monday = Colors.white38;
                          _routine.monday = 0;
                        }
                      });
                    },
                    child: new Text('Mon', style: TextStyle(color: monday)),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.73, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.tuesday == 0) {
                          _routine.tuesday = 1;
                          tuesday = Colors.white;
                        } else {
                          tuesday = Colors.white38;
                          _routine.tuesday = 0;
                        }
                      });
                    },
                    child: new Text('Tue', style: TextStyle(color: tuesday)),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.43, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.wednesday == 0) {
                          _routine.wednesday = 1;
                          wednesday = Colors.white;
                        } else {
                          wednesday = Colors.white38;
                          _routine.wednesday = 0;
                        }
                      });
                    },
                    child: new Text('Wed', style: TextStyle(color: wednesday)),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.13, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.thursday == 0) {
                          _routine.thursday = 1;
                          thursday = Colors.white;
                        } else {
                          thursday = Colors.white38;
                          _routine.thursday = 0;
                        }
                      });
                    },
                    child: new Text('Thu', style: TextStyle(color: thursday)),
                  ),
                ),
                Align(
                  alignment: Alignment(0.13, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.friday == 0) {
                          _routine.friday = 1;
                          friday = Colors.white;
                        } else {
                          friday = Colors.white38;
                          _routine.friday = 0;
                        }
                      });
                    },
                    child: new Text('Fri', style: TextStyle(color: friday)),
                  ),
                ),
                Align(
                  alignment: Alignment(0.43, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.saturday == 0) {
                          _routine.saturday = 1;
                          saturday = Colors.white;
                        } else {
                          saturday = Colors.white38;
                          _routine.saturday = 0;
                        }
                      });
                    },
                    child: new Text('Sat', style: TextStyle(color: saturday)),
                  ),
                ),
                Align(
                  alignment: Alignment(0.73, -0.6),
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_routine.sunday == 0) {
                          _routine.sunday = 1;
                          sunday = Colors.white;
                        } else {
                          sunday = Colors.white38;
                          _routine.sunday = 0;
                        }
                      });
                    },
                    child: new Text('Sun', style: TextStyle(color: sunday)),
                  ),
                ),
                Align(
                  alignment: Alignment(0.8, -0.9),
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
                    ),
                    child: ButtonTheme(
                      //layoutBehavior: ButtonBarLayoutBehavior.padded,
                      alignedDropdown: true,
                      buttonColor: Colors.transparent,
                      child: new DropdownButton(
                        iconDisabledColor: Colors.transparent,
                        iconEnabledColor: Colors.transparent,
                        style: TextStyle(),
                        underline: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment(-1.15, 2.0),
                              child: Container(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.white30,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0, -2),
                              child: Container(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: CustomPaint(
                                  size: Size.square(2),
                                  painter: new Drawhorizontalline(75),
                                ),
                              ),
                            ),
                          ],
                        ),
                        hint: SizedBox(
                          width: 100.0, // for example
                          child: Text(
                            'Points',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.white54, fontSize: 15.0),
                          ),
                        ),
                        value: _selectedPoints,
                        onChanged: (newValue) {
                          setState(() {
                            _routine.points = int.parse(newValue);
                            _selectedPoints = newValue;
                          });
                        },
                        items: _points.map((point) {
                          return DropdownMenuItem(
                              value: point,
                              child: Builder(
                                builder: (BuildContext context) {
                                  final bool isDropDown =
                                      context.ancestorStateOfType(TypeMatcher<
                                              _RoutinePageState>()) ==
                                          null;
                                  if (isDropDown) {
                                    return SizedBox(
                                      width: 100.0, // for example
                                      child: Text(
                                        point,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: 100.0, // for example
                                      child: Text(
                                        point,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 20),
                                      ),
                                    );
                                  }
                                },
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: navigateBack,
      ),
    );
  }

  Future<bool> navigateBack() async {
    if (exit) {
      exit = false;
      await _routineBloc.updateRoutineTask(_routine);
      await _routineBloc.setRoutineSettings();
      return true;
    }
    return false;
  }
}
