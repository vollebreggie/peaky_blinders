import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Pages/DashboardPage.dart';
import 'package:peaky_blinders/Pages/IntroductionPage.dart';
import 'package:peaky_blinders/Pages/LoginPage.dart';
import 'package:peaky_blinders/Repositories/ErrorRepository.dart';
import 'package:peaky_blinders/Repositories/UserRepository.dart';

Future<Widget> selectPage(userBloc, projectBloc, taskBloc, routineTaskBloc,
    personalBloc, skillBloc, problemBloc) async {
  Widget _defaultHome = new LoginPage();
  User user = await UserRepository.get().getLoggedInUser();
  if (user != null) {
    if (user.configured == 1) {
      _defaultHome = MyHomePage();
    } else if (user.configured == 0) {
      personalBloc.setUser(user);
      _defaultHome = IntroductionPage();
    }
    await initData(userBloc, projectBloc, taskBloc, routineTaskBloc, skillBloc,
        problemBloc);
  }
  return _defaultHome;
}

Future initData(UserBloc userBloc, ProjectBloc projectBloc, TaskBloc taskBloc, RoutineSettingBloc routineTaskBloc, SkillBloc skillBloc,
    ProblemBloc problemBloc) async {
  //retrieve data from server
  await userBloc.setUser();
  await projectBloc.syncEverything();
  await routineTaskBloc.syncRoutineSettings();
  await skillBloc.syncSkill();
  await problemBloc.syncProblem();
  await userBloc.getCompletedTasksToday();
  await userBloc.getPointsGainedToday();
  await userBloc.getChartData();
  await userBloc.getCompletedTasks();
  await userBloc.getCompletedPoints();

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
}

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    //Zone.current.handleUncaughtError();
     //   details.exception.message, details.exception.stack);
  };

  runZoned<Future<Null>>(() async {
    //load data, then app
    ProjectBloc projectBloc = new ProjectBloc();
    UserBloc userBloc = new UserBloc();
    TaskBloc taskBloc = new TaskBloc();
    PersonalBloc personalBloc = new PersonalBloc();
    RoutineSettingBloc routineTaskBloc = new RoutineSettingBloc();
    SkillBloc skillBloc = new SkillBloc();
    ProblemBloc problemBloc = new ProblemBloc();
    runApp(new PeakyApp(
        await selectPage(userBloc, projectBloc, taskBloc, routineTaskBloc,
            personalBloc, skillBloc, problemBloc),
        userBloc,
        projectBloc,
        taskBloc,
        routineTaskBloc,
        personalBloc,
        skillBloc,
        problemBloc));
  }, onError: (error, stackTrace) async {
    //await ErrorRepository.get().sendErrorMessage(error.message.toString(), stackTrace.toString());
  });
}

class PeakyApp extends StatelessWidget {
  UserBloc _userBloc;
  ProjectBloc _projectBloc;
  TaskBloc _taskBloc;
  RoutineSettingBloc _routineSettingBloc;
  PersonalBloc _personalBloc;
  SkillBloc _skillBloc;
  ProblemBloc _problemBloc;
  Widget _page;

  PeakyApp(Widget page, userBloc, projectBloc, taskBloc, routineBloc,
      personalBloc, skillBloc, problemBloc) {
    this._page = page;
    this._userBloc = userBloc;
    this._projectBloc = projectBloc;
    this._taskBloc = taskBloc;
    this._routineSettingBloc = routineBloc;
    this._personalBloc = personalBloc;
    this._skillBloc = skillBloc;
    this._problemBloc = problemBloc;
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      bloc: _userBloc,
      child: BlocProvider<ProjectBloc>(
        bloc: _projectBloc,
        child: BlocProvider<MileStoneBloc>(
          bloc: MileStoneBloc(),
          child: BlocProvider<RoutineSettingBloc>(
            bloc: _routineSettingBloc,
            child: BlocProvider<TaskBloc>(
              bloc: _taskBloc,
              child: BlocProvider<TVBloc>(
                bloc: TVBloc(),
                child: BlocProvider<PageBloc>(
                  bloc: PageBloc(),
                  child: BlocProvider<SkillBloc>(
                    bloc: _skillBloc,
                    child: BlocProvider<PersonalBloc>(
                      bloc: _personalBloc,
                      child: BlocProvider<ProblemBloc>(
                        bloc: _problemBloc,
                        child: MaterialApp(
                          title: 'Peaky Blinder',
                          theme: ThemeData(
                            primarySwatch: Colors.blue,
                            hintColor: Colors.white,
                          ),
                          home: _page,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
