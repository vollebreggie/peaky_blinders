

import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';

class ProjectBloc implements BlocBase {
  List<Project> _projects;

  //
  // Stream to handle the counter
  //
  StreamController<List<Project>> _projectController = StreamController<List<Project>>.broadcast();
  StreamSink<List<Project>> get _inProject => _projectController.sink;
  Stream<List<Project>> get outProject => _projectController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get fetchProject => _actionController.sink;

  //
  // Constructor
  //
  ProjectBloc() {
   
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionController.close();
    _projectController.close();
  }

  void _handleLogic(data) async {
     _projects = await Repository.get().getProjects();
     _inProject.add(_projects);
  }
}
