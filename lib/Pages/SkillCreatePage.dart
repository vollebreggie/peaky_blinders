import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Pages/MilestonePage.dart';
import 'package:peaky_blinders/Pages/TVUserListPage.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/widgets/MileStone.dart';

class SkillCreatePage extends StatefulWidget {
  @override
  _SkillCreateState createState() => _SkillCreateState();
}

class _SkillCreateState extends State<SkillCreatePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  FocusNode focusNode = FocusNode();

  SkillBloc skillBloc;
  File _imageFile;
  String image;
  bool exit = true;

  _settitleValue() {
    if (titleController.text != "") {
      skillBloc.getCurrentSkill().title = titleController.text;
    }
  }

  _setDescriptionValue() {
    skillBloc.getCurrentSkill().description = descriptionController.text;
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
    skillBloc = BlocProvider.of<SkillBloc>(context);
    titleController.text = skillBloc.getCurrentSkill().title;
    FocusScope.of(context).requestFocus(focusNode);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(60, 65, 74, 1),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                backgroundColor: Color.fromRGBO(60, 65, 74, 1),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(top: 5, right: 100),
                  title: Stack(
                    children: <Widget>[
                      TextField(
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        focusNode: focusNode,
                        controller: titleController,
                        style: TextStyle(
                          // backgroundColor: Colors.transparent,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          hintText: "Skill title",
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                      ),
                      new Positioned(
                        bottom: 5,
                        right: 0,
                        child: new Container(
                          child: new IconButton(
                            color: Colors.white70,
                            icon: new Icon(
                              Icons.image,
                              size: 40,
                            ),
                            onPressed: getImage,
                          ),
                          //  margin: EdgeInsets.only(left: 280, bottom: 20.0),
                        ),
                      ),
                    ],
                  ),
                  background: _imageFile == null
                      ? new CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: getImageFromServer(context, image),
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
                ),
              ),
            ];
          },
          body: Column(children: <Widget>[
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
          ]),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 80,
              padding: EdgeInsets.all(18),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final SkillBloc skillBloc =
                      BlocProvider.of<SkillBloc>(context);
                   await skillBloc.postSkill(_imageFile, skillBloc.getCurrentSkill());
                   await skillBloc.setSkills();
                  // await projectBloc.setProjectCount();
                  
                  Navigator.pop(context, true);
                  //Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      onWillPop: navigateBack,
    );
  }

  Future<bool> navigateBack() async {
    if (exit) {
      exit = false;
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

  String getImageFromServer(context, image) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    return projectBloc.getImageFromServer(image);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }
}
