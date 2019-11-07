import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Pages/LoginPage.dart';
import 'package:peaky_blinders/Pages/ProblemListPage.dart';
import 'package:peaky_blinders/Pages/SkillListPage.dart';
import 'package:peaky_blinders/Pages/chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:peaky_blinders/widgets/SkillStatsWidget.dart';
import 'package:peaky_blinders/widgets/dashboardStats.dart';
import 'package:peaky_blinders/widgets/personalScoreWidget.dart';
import 'package:peaky_blinders/widgets/taskWidget.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonalPageState();
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class _PersonalPageState extends State<PersonalPage> {
  final firstNameController = TextEditingController();
  User _tempUser = new User(firstName: "Henk");
  File _imageFile;
  UserBloc blocUser;
  SkillBloc skillBloc;
  ProblemBloc problemBloc;

  _setFirstNameValue() {
    _tempUser.firstName = firstNameController.text;
  }

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(_setFirstNameValue);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {
    blocUser = BlocProvider.of<UserBloc>(context);
    skillBloc = BlocProvider.of<SkillBloc>(context);
    problemBloc = BlocProvider.of<ProblemBloc>(context);

    blocUser.getChartData();
    _tempUser = blocUser.getUser();
    firstNameController.text = _tempUser.firstName;

    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    List<charts.Series<LinearSales, int>> _createSampleData() {
      final data = [
        new LinearSales(0, 5),
        new LinearSales(1, 25),
        new LinearSales(2, 100),
        new LinearSales(3, 75),
      ];

      return [
        new charts.Series<LinearSales, int>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }

    return new Scaffold(
      // resizeToAvoidBottomPadding: true,
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: SingleChildScrollView(
        child: new Container(
          // color: Colors.white,
          child: new Container(
            child: new Center(
              child: new Column(children: [
                new Padding(padding: EdgeInsets.only(top: 5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: _imageFile == null
                          ? new CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                              imageUrl:
                                  blocUser.getImageFromServer(_tempUser.image),
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            )
                          : Image.file(_imageFile,
                              fit: BoxFit.fill, width: 40, height: 40),
                    ),
                    new Flexible(
                      child: new Theme(
                        data: new ThemeData(
                            primaryColor: Colors.white70,
                            accentColor: Colors.white70,
                            hintColor: Colors.white30),
                        child: new TextField(
                          controller: firstNameController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              //hintText: blocUser.getUser() != null ? blocUser.getUser().firstName : "Your name",
                              //filled: true,
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    debugPrint('222');
                                  })),
                          style: new TextStyle(
                              fontFamily: "Poppins", color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      child: createTask(context, "Tasks this week",
                          blocUser.completedTask.toString(), Icons.check),
                    ),
                    InkWell(
                      child: createTask(context, "Points this week",
                          blocUser.completedPoints.toString(), Icons.check),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      child: createTask(context, "Skills",
                          skillBloc.getSkillCount().toString(), Icons.build),
                      onTap: () async {
                        await skillBloc.setSkills();
                        await navigateToSkillListPage(context);
                      },
                    ),
                    InkWell(
                      child: createTask(
                          context,
                          "Problems",
                          problemBloc.getProblemCount().toString(),
                          Icons.warning),
                      onTap: () async {
                        await problemBloc.setProblems();
                        await navigateToProblemListPage(context);
                      },
                    ),
                  ],
                ),
                StreamBuilder<List<Skill>>(
                  stream: skillBloc.outSkill,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Skill>> snapshot) {
                    skillBloc
                        .getSkillsForGraph(blocUser.getUser().amountOfSkills);
                    return createSkillsStatistics(context, snapshot.data);
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, top: 25, right: 5),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Card(
                      elevation: 8,
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: Container(
                        //padding: EdgeInsets.only(left: 90.0),
                        child: Center(
                          child: Text(
                            "Log out",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                        height: 80,
                        //color: Colors.transparent,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(128, 0, 0, 1),
                          borderRadius: new BorderRadius.only(
                              topRight: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0),
                              topLeft: const Radius.circular(20.0),
                              bottomLeft: const Radius.circular(20.0)),
                          //color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async => logout(context),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future logout(context) async {
    await blocUser.logout();
    final PageBloc pageBloc = BlocProvider.of<PageBloc>(context);
    pageBloc.page = 0;
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future navigateToSkillListPage(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SkillListPage()));
  }

  Future navigateToProblemListPage(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProblemListPage()));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }
}
