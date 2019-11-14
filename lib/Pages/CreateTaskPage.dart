import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/MileStoneDropdown.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';
import 'package:peaky_blinders/widgets/ClipShadowPart.dart';
import 'package:peaky_blinders/widgets/DrawHorizontalLine.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  ProjectDropdown _selectedProject;
  MileStoneDropdown _selectedMileStone;
  String _image;
  var _task;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  TaskBloc _taskBloc;
  bool exit = true;
  ProjectBloc _projectBloc;
  int _selectionTitle = 0;
  int _selectionDescription = 0;

  _settitleValue() {
    _task.title = _titleController.text;
  }

  _setDescriptionValue() {
    _task.description = _descriptionController.text;
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

    _task = _taskBloc.getProjectTask();
    if (_task != null) {
      _selectedPoints = _task.points.toString();
      _titleController.selection =
          TextSelection.collapsed(offset: _selectionTitle);
      _descriptionController.selection =
          TextSelection.collapsed(offset: _selectionDescription);
      _titleController.text = _task.title;
      _descriptionController.text = _task.description;
      if (_selectedProject == null) {
        _image = _task.runtimeType == ProjectTask
            ? _task.project.imagePathServer
            : "example.jpg";
      }
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
                _task.runtimeType == ProjectTask
                    ? Align(
                        alignment: Alignment(0.8, -0.95),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
                          ),
                          child: ButtonTheme(
                            //layoutBehavior: ButtonBarLayoutBehavior.padded,
                            alignedDropdown: true,
                            buttonColor: Colors.transparent,
                            child: new StreamBuilder<List<ProjectDropdown>>(
                              stream: _projectBloc.outProjectDropdown,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ProjectDropdown>>
                                      snapshot) {
                                _projectBloc.getDropdownProject();
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                } else {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    if (_selectedProject == null) {
                                      ProjectDropdown result = snapshot.data
                                          .firstWhere(
                                              (o) => o.id == _task.project.id);
                                      _selectedProject = result;

                                      milestoneBloc.getDropdownMileStone(
                                          _selectedProject.id);
                                    }
                                  }
                                }
                                return new DropdownButton<ProjectDropdown>(
                                  iconDisabledColor: Colors.transparent,
                                  iconEnabledColor: Colors.transparent,
                                  underline: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment(-1.15, 2.0),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
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
                                          padding:
                                              const EdgeInsets.only(top: 25.0),
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
                                      'Projects',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          color: Colors.white54,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  value: _selectedProject,
                                  onChanged: (ProjectDropdown value) async {
                                    var project = _projectBloc
                                        .getProjectsDragAndDrop()
                                        .firstWhere((p) => p.id == value.id);
                                    (_taskBloc.getTasksToday().first
                                            as ProjectTask)
                                        .project = project;
                                    (_taskBloc.getNextTask() as ProjectTask)
                                        .project = project;
                                    _selectedProject = value;
                                    _selectedMileStone = null;
                                    await milestoneBloc.getDropdownMileStone(
                                        _selectedProject.id);
                                    setState(() {
                                      _image = value.imagePathServer;
                                    });
                                  },
                                  items: snapshot.data != null
                                      ? snapshot.data.map<
                                          DropdownMenuItem<
                                              ProjectDropdown>>(
                                          (ProjectDropdown item) {
                                          return DropdownMenuItem(
                                              value: item,
                                              child: Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  final bool isDropDown = context
                                                          .ancestorStateOfType(
                                                              TypeMatcher<
                                                                  _CreateTaskPageState>()) ==
                                                      null;
                                                  if (isDropDown) {
                                                    return SizedBox(
                                                      width:
                                                          200.0, // for example
                                                      child: Text(
                                                        item.title,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox(
                                                      width:
                                                          100.0, // for example
                                                      child: Text(
                                                        item.title.length <= 9
                                                            ? item.title
                                                            : item.title
                                                                    .substring(
                                                                        0, 9) +
                                                                "..",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ));
                                        }).toList()
                                      : [],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
                _task.runtimeType == ProjectTask
                    ? Align(
                        alignment: Alignment(0.8, -0.65),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
                          ),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            buttonColor: Colors.transparent,
                            child: new StreamBuilder<List<MileStoneDropdown>>(
                              stream: milestoneBloc.outMileStoneDropdown,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MileStoneDropdown>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                } else {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    if (_selectedMileStone == null) {
                                      if (snapshot.data.first.projectId ==
                                          _task.projectId) {
                                        _selectedMileStone = snapshot.data
                                            .firstWhere((m) =>
                                                m.id == _task.milestoneId);
                                      } else {
                                        _selectedMileStone =
                                            snapshot.data.first;
                                      }
                                    }
                                  }
                                }
                                return new DropdownButton<MileStoneDropdown>(
                                  iconDisabledColor: Colors.transparent,
                                  iconEnabledColor: Colors.transparent,
                                  underline: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment(-1.15, 2.0),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
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
                                          padding:
                                              const EdgeInsets.only(top: 25.0),
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
                                      'Milestones',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          color: Colors.white54,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  value: _selectedMileStone,
                                  onChanged: (MileStoneDropdown value) {
                                    setState(() {
                                      _selectedMileStone = value;
                                    });
                                  },
                                  items: snapshot.data != null
                                      ? snapshot.data.map<
                                          DropdownMenuItem<
                                              MileStoneDropdown>>(
                                          (MileStoneDropdown item) {
                                          return DropdownMenuItem(
                                              value: item,
                                              child: Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  final bool isDropDown = context
                                                          .ancestorStateOfType(
                                                              TypeMatcher<
                                                                  _CreateTaskPageState>()) ==
                                                      null;
                                                  if (isDropDown) {
                                                    return SizedBox(
                                                      width:
                                                          200.0, // for example
                                                      child: Text(
                                                        item.title,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox(
                                                      width:
                                                          100.0, // for example
                                                      child: Text(
                                                        item.title.length <= 18
                                                            ? item.title
                                                            : item.title
                                                                    .substring(
                                                                        0, 18) +
                                                                "..",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ));
                                        }).toList()
                                      : [],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment(
                      0.8, _task.runtimeType == ProjectTask ? -0.35 : -0.9),
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
                            _task.points = int.parse(newValue);
                            _selectedPoints = newValue;
                          });
                          if (_taskBloc.getTasksToday().length != 0) {
                            _taskBloc.getTasksToday().first.points =
                                int.parse(newValue);
                          }
                        },
                        items: _points.map((point) {
                          return DropdownMenuItem(
                              value: point,
                              child: Builder(
                                builder: (BuildContext context) {
                                  final bool isDropDown =
                                      context.ancestorStateOfType(TypeMatcher<
                                              _CreateTaskPageState>()) ==
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
                ),
                Align(
                  alignment: Alignment(1.0, 0.5),
                  child: ProgressButton(
                    borderRadius: 20,
                    defaultWidget: const Icon(
                      Icons.save,
                      size: 50,
                      color: Colors.white,
                    ),
                    progressWidget: const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                    color: Color.fromRGBO(8, 68, 22, 0.98),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.12,
                    onPressed: () async {
                      final UserBloc userBloc =
                          BlocProvider.of<UserBloc>(context);
                      _task.user = userBloc.getUser();
                      _task.skills = _taskBloc.selectedSkills;
                      final MileStoneBloc milestoneBloc =
                          BlocProvider.of<MileStoneBloc>(context);
                      milestoneBloc.getCurrentMileStone().tasks.add(_task);

                      Navigator.pop(context);
                    },
                  ),
                ),
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
      return true;
    }
    return false;
  }
}
