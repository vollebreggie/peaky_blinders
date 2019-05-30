import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';

class TaskBloc implements BlocBase {
  List<Task> _tasksToday;
  List<Task> _tasksTomorrow;
  Task _nextTask;
  ProjectTask _currentProjectTask;
  int projectId = 0;
  int counter = 0;

  //
  // Stream to handle the counter
  //
  StreamController<List<Task>> _taskController =
      StreamController<List<Task>>.broadcast();
  StreamSink<List<Task>> get _inTask => _taskController.sink;
  Stream<List<Task>> get outTask => _taskController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionProjectController = StreamController();
  StreamSink get fetchProjectTask => _actionProjectController.sink;

  //
  // Constructor
  //
  TaskBloc() {
    //_actionProjectController.stream.listen(getProjectTasks);
    TaskRepository.get().syncProjectTasks();
    _tasksToday = [];
    _tasksTomorrow = [];
  }

  void dispose() {
    _actionProjectController.close();
    _taskController.close();
  }

  Future changePriorityOfTasksToday(before, after) async {
    if (_tasksToday[before].runtimeType == ProjectTask) {
      ProjectTask task = _tasksToday[before];
      _tasksToday.removeAt(before);
      _tasksToday.insert(after, task);
    } else if (_tasksToday[before].runtimeType == RoutineTask) {
      RoutineTask task = _tasksToday[before];
      _tasksToday.removeAt(before);
      _tasksToday.insert(after, task);
    }

    for (int i = 0; i < _tasksToday.length; i++) {
      _tasksToday[i].place = i;
    }

    List<ProjectTask> projectTasks = [];
    List<RoutineTask> routineTasks = [];

    for (int i = 0; i < _tasksToday.length; i++) {
      if (_tasksToday[i].runtimeType == ProjectTask) {
        projectTasks.add(_tasksToday[i]);
      } else if (_tasksToday[i].runtimeType == RoutineTask) {
        routineTasks.add(_tasksToday[i]);
      }
    }

    await TaskRepository.get().changePriorityProjectTasks(projectTasks);
    await TaskRepository.get().changePriorityRoutineTasks(routineTasks);
    await setNextTask();
  }

  Future changePriorityOfTasksTomorrow(before, after) async {
    if (_tasksTomorrow[before].runtimeType == ProjectTask) {
      ProjectTask task = _tasksTomorrow[before];
      _tasksTomorrow.removeAt(before);
      _tasksTomorrow.insert(after, task);
    } else if (_tasksTomorrow[before].runtimeType == RoutineTask) {
      RoutineTask task = _tasksTomorrow[before];
      _tasksTomorrow.removeAt(before);
      _tasksTomorrow.insert(after, task);
    }

    for (int i = 0; i < _tasksTomorrow.length; i++) {
      _tasksTomorrow[i].place = i;
    }

    List<ProjectTask> projectTasks = [];
    List<RoutineTask> routineTasks = [];

    for (int i = 0; i < _tasksTomorrow.length; i++) {
      if (_tasksTomorrow[i].runtimeType == ProjectTask) {
        projectTasks.add(_tasksTomorrow[i]);
      } else if (_tasksTomorrow[i].runtimeType == RoutineTask) {
        routineTasks.add(_tasksTomorrow[i]);
      }
    }

    await TaskRepository.get().changePriorityProjectTasks(projectTasks);
    await TaskRepository.get().changePriorityRoutineTasks(routineTasks);
    await setNextTask();
  }

  void setProjectId(int id) {
    this.projectId = id;
  }

  Task getNextTask() {
    return _nextTask;
  }

  List<Task> getTasksToday() {
    return _tasksToday;
  }

  Future createTasksTomorrow(int userId) async {
    await TaskRepository.get().createRoutineTasksForTomorrow(userId);
  }

  void setProjectTask(ProjectTask task) {
    _currentProjectTask = task;
  }

  Future completedTask(Task task) async {
    if (task.runtimeType == ProjectTask) {
      await TaskRepository.get().completeProjectTask(task.id);
    } else if (task.runtimeType == RoutineTask) {
      await TaskRepository.get().completeRoutineTask(task.id);
    }
  }

  ProjectTask getProjectTask() {
    return _currentProjectTask != null
        ? _currentProjectTask
        : new ProjectTask(
            id: 1,
            title: "default",
            description: "default",
            project: new Project(
                id: 1,
                title: "default",
                description: "default",
                imagePathServer: "example.jpg"));
  }

  Future setNextTask() async {
    _nextTask = await TaskRepository.get().getNextTask();
  }

  String getImageFromProject(image) {
    return TaskRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  Future setTasksForToday() async {
    _tasksToday = await TaskRepository.get().getTasksForToday();
  }

  Future getExistingTasksForToday() async {
    _inTask.add(await TaskRepository.get().getExistingTasksForToday());
  }

  Future setProjectTaskForTomorrow(ProjectTask task) async {
    await TaskRepository.get().setProjectTaskTomorrow(task);
  }

  List<Task> getTasksForTomorrow() {
    return _tasksTomorrow;
  }

  Future setTasksForTomorrow() async {
    _tasksTomorrow = await TaskRepository.get().getTasksForTomorrow();
  }

  Future startTasks(ProjectTask task) async {
    await TaskRepository.get().startTask(task);
    await setTasksForToday();
  }

  void getProjectTasks() async {
    if (projectId == 0) {
      _inTask.add(await TaskRepository.get().getProjectTasks());
    } else {
      _inTask.add(
          await TaskRepository.get().getProjectTasksByProjectId(projectId));
    }
  }

  void updateCurrentTask() async {
    await TaskRepository.get().updateProjectTask(_currentProjectTask);
    TaskRepository.get().syncProjectTasks();
  }

  Future updateProjectTask(task) async {
    await TaskRepository.get().updateProjectTask(task);
  }

  void postProjectTask(task) async {
    await TaskRepository.get().createProjectTask(task);
  }

  Future postProjectTaskToday(task) async {
    await TaskRepository.get().createProjectTaskToday(task);
  }
}
