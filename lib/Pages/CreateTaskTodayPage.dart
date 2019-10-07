import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';
import 'package:peaky_blinders/widgets/createSkillCreateTaskWidget.dart';

class CreateTaskTodayPage extends StatefulWidget {
  @override
  _CreateTaskTodayState createState() => _CreateTaskTodayState();
}

class _CreateTaskTodayState extends State<CreateTaskTodayPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Color priorityColors = Colors.white70;
  Color pointsColors = Colors.white70;
  Color titleColors = Colors.white70;
  Color descriptionsColors = Colors.white70;

  List<String> _priorities = ['Trivial', 'Valuable', 'Necessary', 'Paramount'];
  String _selectedPriority;
  List<String> _points = ['1', '2', '4', '8', '12', '18', '32', '45'];
  String _selectedPoints;
  ProjectDropdown _selectedProject;
  String image;
  ProjectTask tempProjectTask;

  _settitleValue() {
    if (titleController.text != "") {
      titleColors = Colors.green;
    } else {
      titleColors = Colors.white70;
    }

    tempProjectTask.title = titleController.text;
  }

  _setDescriptionValue() {
    if (descriptionController.text != "") {
      descriptionsColors = Colors.green;
    } else {
      descriptionsColors = Colors.white70;
    }

    tempProjectTask.description = descriptionController.text;
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

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "Valuable":
        {
          return Colors.yellow;
        }
        break;

      case "Trivial":
        {
          return Colors.green;
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
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    tempProjectTask = taskBloc.getProjectTask();
    //tempProjectTask.project = projectBloc.getCurrentProject();
    titleController.text = tempProjectTask.title;
    descriptionController.text = tempProjectTask.description;
    pointsColors = getPointsColor(tempProjectTask.points);
    priorityColors = getPriorityColor(tempProjectTask.priority);
    _selectedPoints = tempProjectTask.points.toString();
    _selectedPriority = tempProjectTask.priority;
    //image = tempProjectTask.project.imagePathServer;
    return WillPopScope(
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
                      imageUrl: taskBloc.getImageFromProject(image),
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                    new Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 50, bottom: 20.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color.fromRGBO(0, 0, 0, 0.8),
                          ),
                          child: new StreamBuilder<List<ProjectDropdown>>(
                            stream: projectBloc.outProjectDropdown,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ProjectDropdown>> snapshot) {
                              projectBloc.getDropdownProject();
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              } else {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (_selectedProject == null) {
                                    _selectedProject = snapshot.data.first;
                                    image = _selectedProject.imagePathServer;
                                  }
                                  return Container(
                                    child: Center(
                                      child: snapshot.hasData
                                          ? new Align(
                                              alignment:
                                                  FractionalOffset.bottomLeft,
                                              child: Container(
                                                child: DropdownButton<
                                                        ProjectDropdown>(
                                                    style: new TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 30.0),
                                                    onChanged: (ProjectDropdown
                                                        value) {
                                                      _selectedProject = value;

                                                      setState(() {
                                                        _selectedProject =
                                                            value;
                                                        image = value
                                                            .imagePathServer;
                                                      });
                                                    },
                                                    value: _selectedProject,
                                                    items: snapshot.data != null
                                                        ? snapshot.data.map<
                                                            DropdownMenuItem<
                                                                ProjectDropdown>>(
                                                            (ProjectDropdown
                                                                value) {
                                                            return DropdownMenuItem<
                                                                ProjectDropdown>(
                                                              value: value,
                                                              child: Text(
                                                                  value.title,
                                                                  style: new TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize:
                                                                          30.0)),
                                                            );
                                                          }).toList()
                                                        : SizedBox(
                                                            height: 0.0)),
                                              ))
                                          : CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    // new Align(
                    //   alignment: FractionalOffset.bottomLeft,
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 20.0),
                    //     child: LinearProgressIndicator(
                    //         backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                    //         value: tempProjectTask.project.getProgress(),
                    //         valueColor: AlwaysStoppedAnimation(Colors.green)),
                    //   ),
                    // )
                  ]),
                  backgroundColor: Colors.transparent,
                ),
              ];
            },
            body: Center(
              child: SingleChildScrollView(
                child: new Column(
                  children: [
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
                                        right:
                                            MediaQuery.of(context).size.width *
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
                                        tempProjectTask.points =
                                            int.parse(newValue);
                                        pointsColors =
                                            getPointsColor(int.parse(newValue));
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
                          padding:
                              EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
                          child: ClipPath(
                            clipper: TrapeziumClipper(),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(8, 68, 22, 1.0),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0))),
                              //color: Color.fromRGBO(6, 32, 12, 1.0),
                              //padding: EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          padding: EdgeInsets.only(top: 10),
                                          child: Icon(Icons.show_chart,
                                              color: Colors.white, size: 35),
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
                    Stack(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: 20.0, top: 10.0, right: 5),
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
                          padding:
                              EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
                          child: ClipPath(
                            clipper: TrapeziumClipper(),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(8, 68, 22, 1.0),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0))),
                              //color: Color.fromRGBO(6, 32, 12, 1.0),
                              //padding: EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 56,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          padding: EdgeInsets.only(top: 10),
                                          child: Icon(Icons.description,
                                              color: Colors.white, size: 35),
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
                          stream: taskBloc.outSkill,
                          initialData: [],
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Skill>> snapshot) {
                            taskBloc.getCreateSkills();
                            return createSelectedSkillssCreateTask(
                                context, snapshot.data);
                          }),
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
                                child: Center(
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                    controller:
                                                        descriptionController,
                                                    cursorColor: Colors.white,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 100,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    decoration:
                                                        new InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Description'),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(12, 62, 18, 0.8),
          child: const Icon(Icons.save),
          onPressed: () async {
            // SaveProjectTask(context);
            final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
            final ProjectBloc projectBloc =
                BlocProvider.of<ProjectBloc>(context);

            Project project = await projectBloc
                .getProjectWithMilestoneById(_selectedProject.id);
            tempProjectTask.userId = userBloc.getUser().id;
            tempProjectTask.projectId = project.id;
            tempProjectTask.started = DateTime.now();
            MileStone milestone = project.milestones
                    .where((m) =>
                        m.startDate.isBefore(DateTime.now()) &&
                        m.endDate.isAfter(DateTime.now()))
                    .isNotEmpty
                ? project.milestones
                    .where((m) =>
                        m.startDate.isBefore(DateTime.now()) &&
                        m.endDate.isAfter(DateTime.now()))
                    .first
                : project.milestones.last;

            tempProjectTask.place = milestone.tasks.length;
            tempProjectTask.milestoneId = milestone.id;
            tempProjectTask.skills = taskBloc.selectedSkills;
            await taskBloc.postProjectTaskToday(tempProjectTask);

            await taskBloc.setTasksForToday();
            await taskBloc.setNextTask();
            Navigator.pop(context);
            Navigator.of(context).pop();
          },
        ),
      ),
      onWillPop: navigateBack,
    );
  }

  Future<bool> navigateBack() async {
    return true;
  }
}
