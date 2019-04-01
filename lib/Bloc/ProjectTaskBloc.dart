

import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';

class ProjectTaskBloc implements BlocBase {
  List<ProjectTask> _projectTasks;

  //
  // Stream to handle the counter
  //
  StreamController<List<ProjectTask>> _projectTaskController = StreamController<List<ProjectTask>>.broadcast();
  StreamSink<List<ProjectTask>> get _inProjectTask => _projectTaskController.sink;
  Stream<List<ProjectTask>> get outProjectTask => _projectTaskController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionProjectController = StreamController();
  StreamSink get fetchProjectTask => _actionProjectController.sink;

  //
  // Constructor
  //
  ProjectTaskBloc() {
   
    _actionProjectController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionProjectController.close();
    _projectTaskController.close();
  }

  void _handleLogic(data) async {
     _projectTasks = await Repository.get().getProjectTasks();
     _inProjectTask.add(_projectTasks);
  }
}
