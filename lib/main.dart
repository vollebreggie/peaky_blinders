import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectTaskBloc.dart';
import 'package:peaky_blinders/Pages/DashboardPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      bloc: ProjectBloc(),
      child: BlocProvider<ProjectTaskBloc>(
        bloc: ProjectTaskBloc(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              hintColor: Colors.white,
            ),
            home: MyHomePage()),
      ),
    );
  }
}
