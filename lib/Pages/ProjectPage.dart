import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Pages/MilestonePage.dart';
import 'package:peaky_blinders/Pages/TVUserListPage.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/widgets/ClipShadowPart.dart';
import 'package:peaky_blinders/widgets/MileStone.dart';
import 'package:peaky_blinders/widgets/SelectedUsers.dart';
import 'package:peaky_blinders/widgets/selectedProblemsWidget.dart';

class ProjectPage extends StatefulWidget {
  @override
  _Project createState() => _Project();
}

class _Project extends State<ProjectPage> {
  final titleController = TextEditingController();
  ProjectBloc projectBloc;
  MileStoneBloc mileStoneBloc;
  File _imageFile;
  String image;
  bool exit = true;

  _settitleValue() {
    if (titleController.text != "") {
      projectBloc.getCurrentProject().title = titleController.text;
    } else {
      // titleColors = Colors.white70;
    }
    //tempProject.title = titleController.text;
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(_settitleValue);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    mileStoneBloc = BlocProvider.of<MileStoneBloc>(context);
    titleController.text = projectBloc.getCurrentProject().title;

    SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light;

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
      child: WillPopScope(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(44, 44, 44, 1),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: false,
                    title: Stack(
                      children: <Widget>[
                        new Positioned(
                          top: 0,
                          right: 20,
                          child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              cursorColor: Colors.white,
                              textAlign: TextAlign.center,
                              controller: titleController,
                              style: TextStyle(
                                // backgroundColor: Colors.transparent,
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                              decoration: InputDecoration(
                                hintText: "Project Title",
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        new Positioned(
                          right: 20,
                          child: new Container(
                            child: new IconButton(
                              color: Colors.white70,
                              icon: new Icon(
                                Icons.image,
                                size: 55,
                              ),
                              onPressed: getImage,
                            ),
                            //  margin: EdgeInsets.only(left: 280, bottom: 20.0),
                          ),
                        ),
                      ],
                    ),
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
                              child: _imageFile == null
                                  ? new CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width,
                                      imageUrl: getImageFromServer(
                                          context,
                                          projectBloc
                                              .getCurrentProject()
                                              .imagePathServer),
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    )
                                  : Image.file(
                                      _imageFile,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
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
              body: Container(
                child: new Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 45),
                      height: 65,
                      child: StreamBuilder<List<User>>(
                          stream: projectBloc.outUser,
                          initialData: [],
                          builder: (BuildContext context,
                              AsyncSnapshot<List<User>> snapshot) {
                            projectBloc.getUsers();
                            return createSelectedUsers(context, snapshot.data);
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 110),
                      height: 65,
                      child: StreamBuilder<List<Problem>>(
                          stream: projectBloc.outProblems,
                          initialData: [],
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Problem>> snapshot) {
                            projectBloc.getProblems();
                            return createSelectedProblems(
                                context, snapshot.data);
                          }),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 185.0),
                        child: new DragAndDropList<MileStone>(
                          mileStoneBloc.milestones,
                          itemBuilder: (BuildContext context, item) {
                            return new SizedBox(
                                child: InkWell(
                              child: createMileStone(context, item),
                              onTap: () async {
                                ProjectBloc projectBloc =
                                    BlocProvider.of<ProjectBloc>(context);
                                MileStoneBloc milestoneBloc =
                                    BlocProvider.of<MileStoneBloc>(context);
                                projectBloc.selectedMilestone = item;
                                milestoneBloc.setCurrentMileStone(item);
                                await navigateToMilestonePage(context);
                              },
                              onDoubleTap: () {
                                _showDeleteDialog(context, item);
                              },
                            ));
                          },
                          onDragFinish: (before, after) {
                            MileStone data = mileStoneBloc.milestones[before];
                            mileStoneBloc.milestones.removeAt(before);
                            data.place = after;
                            mileStoneBloc.milestones.insert(after, data);
                          },
                          canBeDraggedTo: (one, two) => true,
                          dragElevation: 8.0,
                        )),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: null,
              backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
              child: const Icon(Icons.add),
              onPressed: () {
                mileStoneBloc
                    .createMileStone(projectBloc.getCurrentProject().id);

                setState(() {});
              },
            ),
          ),
          onWillPop: navigateBack),
    );
  }

  Future<bool> navigateBack() async {
    if (exit) {
      exit = false;
      projectBloc.getCurrentProject().milestones = mileStoneBloc.milestones;
      projectBloc.updateCurrentProject(null);
      mileStoneBloc.milestones = null;
      projectBloc.selectedProjectTask = null;
      projectBloc.setCurrentProject(null);
      mileStoneBloc.setCurrentMileStone(null);
      return true;
    }
    return false;
  }

  Future navigateToUserListPage(context) async {
    //tvBloc.syncUnselectedUsers();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TVUserListPage()));
  }

  Future navigateToMilestonePage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MilestonePage()));
  }

  List<Widget> getImageOfUser(context, users) {
    List<Widget> widgets = [];

    widgets.addAll(users
        .map<Widget>((user) => Container(
              padding: EdgeInsets.only(right: 5),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: new CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: 40,
                  width: 40,
                  imageUrl: getImageFromServer(context, user.image),
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ))
        .toList());

    widgets.add(
      new IconButton(
        color: Colors.white70,
        icon: new Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () => navigateToUserListPage(context),
      ),
    );

    return widgets;
  }

  String getImageFromServer(context, image) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    return projectBloc.getImageFromServer(image);
  }

  Card makeCard(MileStone milestone, BuildContext context) => Card(
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
          child: makeListTile(milestone, context),
        ),
      );

  ListTile makeListTile(MileStone milestone, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 5),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 4.0, color: Colors.white24))),
          child: Text(
            milestone.getPoints().toString(),
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          milestone.title,
          style: TextStyle(
              color: Colors.white, fontFamily: "Monsterrat", fontSize: 23),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              // flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Text("Tasks: " + milestone.tasks.length.toString(),
                      style: TextStyle(color: Colors.white30, fontSize: 10))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          projectBloc.selectedMilestone = milestone;
          await navigateToMilestonePage(context);
        },
      );

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }

  void _showDeleteDialog(context, MileStone milestone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        MileStoneBloc milestoneBloc = BlocProvider.of<MileStoneBloc>(context);
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Milestone?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  if (milestone.id != 0) {
                    int projectId = milestone.projectId;
                    await milestoneBloc.deleteMileStoneById(milestone.id);
                  }
                  milestoneBloc.milestones.remove(milestone);
                  setState(() {});
                  Navigator.of(context).pop();
                },
                splashColor: Colors.grey,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Container(
                  //margin: const EdgeInsets.all(10.0),
                  child: Text('Delete'),
                ),
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
}
