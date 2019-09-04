import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Pages/DashboardPage.dart';
import 'package:peaky_blinders/Pages/mastersPage.dart';
import 'package:peaky_blinders/main.dart';

class ExplainProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ExplainProjectPageState();
}

class _ExplainProjectPageState extends State<ExplainProjectPage>
    with SingleTickerProviderStateMixin {
  bool _loadingInProgress;
  String _errorMessage;
  Animation<double> _angleAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _controller;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _loadingInProgress = false;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.grey[500],
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: new AssetImage("assets/introduction2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  "The next step: Creating a plan for the first problem",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                  textAlign: TextAlign.center,
                )),
            _loadingInProgress
                ? Center(
                    child: _buildAnimation(),
                  )
                : Container(padding: EdgeInsets.only(top: 100)),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Create plans for the problems you want to tackle. Try to be as nuanced as you can. The smaller the tasks, the better.",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(padding: EdgeInsets.only(top: 100)),
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
                        "Go to Dashboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    height: 80,
                    //color: Colors.transparent,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(8, 68, 22, 1.0),
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
              onTap: () async => navigateToHomePage(context),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToHomePage(context) async {
    if (!done) {
      done = true;
      _loadingInProgress = true;
      //TODO:: set loader
      PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
      SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
      ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
      await personalBloc.sendPersonalData();
      await problemBloc.setProblems();
      await skillBloc.setSkills();
      _loadingInProgress = false;
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    }
  }
}
