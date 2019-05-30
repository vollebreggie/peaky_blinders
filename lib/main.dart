import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/MileStoneBloc.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/TVBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Pages/DashboardPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      bloc: UserBloc(),
      child: BlocProvider<ProjectBloc>(
        bloc: ProjectBloc(),
        child: BlocProvider<MileStoneBloc>(
          bloc: MileStoneBloc(),
          child: BlocProvider<RoutineSettingBloc>(
            bloc: RoutineSettingBloc(),
            child: BlocProvider<TaskBloc>(
              bloc: TaskBloc(),
              child: BlocProvider<TVBloc>(
                bloc: TVBloc(),
                child: BlocProvider<PageBloc>(
                  bloc: PageBloc(),
                  child: MaterialApp(
                      title: 'Peaky Blinder',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        hintColor: Colors.white,
                      ),
                      home: MyHomePage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
