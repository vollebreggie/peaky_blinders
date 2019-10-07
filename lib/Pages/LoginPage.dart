import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Pages/DashboardPage.dart';
import 'package:peaky_blinders/Pages/IntroductionPage.dart';
import 'package:validate/validate.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _loadingInProgress;
  bool _error;
  String _errorMessage;
  Animation<double> _angleAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _controller;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  Future initData(context) async {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final PageBloc pageBloc = BlocProvider.of<PageBloc>(context);
    final SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
    final ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final RoutineSettingBloc routineTaskBloc =
        BlocProvider.of<RoutineSettingBloc>(context);

    //retrieve data from server
    await projectBloc.syncEverything();
    await routineTaskBloc.syncRoutineSettings();
    await skillBloc.syncSkill();
    await userBloc.getCompletedTasksToday();
    await userBloc.getPointsGainedToday();
    await userBloc.getChartData();
    await userBloc.getCompletedTasks();
    await userBloc.getCompletedPoints();
    await problemBloc.syncProblem();
    
    //set data for pages
    await routineTaskBloc.setRoutineSettings();
    await taskBloc.setTasksForToday();
    await projectBloc.setProjectCount();
    await taskBloc.setNextTask();
    await taskBloc.createTasksTomorrow();
    await skillBloc.setSkills();
    await problemBloc.setProblems();
    await skillBloc.getSkillsForGraph(userBloc.getUser().amountOfSkills);
    await skillBloc.syncSkills();
    await projectBloc.setProjects();
    pageBloc.controller = new PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  Future navigateToHomePage(context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

  Future navigateToIntroductionPage(context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => IntroductionPage()));
  }

  @override
  void initState() {
    super.initState();
    _loadingInProgress = false;
    _error = false;
    _errorMessage = "";

    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );

    _angleAnimation = new Tween(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation.addStatusListener((status) {
      if (_loadingInProgress) {
        _controller.repeat();
      }
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation() {
    double angleInDegrees = _angleAnimation.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * pi,
      child: new Container(
        child: Image.asset(
          'assets/spinner_reversed.png',
          width: 75.0,
          height: 75.0,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        height: 75,
        width: MediaQuery.of(context).size.width);
  }

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);

    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/splashscreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          child: new Container(
            child: new Center(
              child: new Column(children: [
                new Padding(padding: EdgeInsets.only(top: 25.0)),
                _loadingInProgress
                    ? Center(
                        child: _buildAnimation(),
                      )
                    : _error
                        ? _buildErrorMessage()
                        : Padding(
                            padding: EdgeInsets.only(top: 75.0),
                          ),
                new Padding(padding: EdgeInsets.only(top: 25.0)),
                new TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.white,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.white)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  style:
                      new TextStyle(fontFamily: "Poppins", color: Colors.white),
                ),
                new Padding(padding: EdgeInsets.only(top: 20.0)),
                new TextFormField(
                  controller: _passwordController,
                  cursorColor: Colors.white,
                  obscureText: true,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.white)),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: _validatePassword,
                  keyboardType: TextInputType.text,
                  style:
                      new TextStyle(fontFamily: "Poppins", color: Colors.white),
                ),
                new Padding(padding: EdgeInsets.only(top: 20.0)),
                new SizedBox(
                  width: 300,
                  height: 50.0,
                  child: new OutlineButton(
                    splashColor: Colors.white,
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0)),
                    child: Text("Login",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.white)),
                    onPressed: () async {
                      _error = false;
                      _loadingInProgress = true;
                      if (await userBloc.login(
                          _emailController.text, _passwordController.text)) {
                        if (userBloc.getUser().configured == 1) {
                          await initData(context);
                          _loadingInProgress = false;
                          await navigateToHomePage(context);
                        } else if (userBloc.getUser().configured == 0) {
                          _loadingInProgress = false;
                          personalBloc.setUser(userBloc.getUser());
                          await navigateToIntroductionPage(context);
                        }
                      } else {
                        //TODO:: error message something went wrong.
                        _error = true;
                        _loadingInProgress = false;
                        _errorMessage = "Password doesn't exist";
                      }
                    },
                    borderSide: BorderSide(
                      color: Colors.white, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
