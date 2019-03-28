import 'dart:async';

import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';


class ProjectTaskBloc {
  final _projectTasksController = StreamController<List<ProjectTask>>.broadcast();

  get projectTasks => _projectTasksController.stream;

  dispose() {
    _projectTasksController.close();
  }

  getCarts() async {
    _projectTasksController.sink.add(await Repository.get().getProjectTasks());
  }

  ProjectTaskBloc() {
    getCarts();
  }

  delete(int id) {
    //Repository.get().
    getCarts();
  }

  add(ProjectTask projectTask) {
    Repository.get().updateProjectTask(projectTask);
    getCarts();
  }
}