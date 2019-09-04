import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/ProjectTaskSkill.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Repositories/RoutineSettingRepository.dart';
import 'package:peaky_blinders/Repositories/SkillRepository.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';

class TaskBloc implements BlocBase {
  List<Task> _tasksToday;
  List<Task> _tasksTomorrow;
  List<Skill> selectedSkills;
  List<Skill> skills;

  Task _nextTask;
  ProjectTask _currentProjectTask;
  int projectId = 0;
  int counter = 0;

  StreamController<List<Skill>> _skillController =
      StreamController<List<Skill>>.broadcast();
  StreamSink<List<Skill>> get _inSkill => _skillController.sink;
  Stream<List<Skill>> get outSkill => _skillController.stream;

  StreamController<List<Task>> _taskController =
      StreamController<List<Task>>.broadcast();
  StreamSink<List<Task>> get _inTask => _taskController.sink;
  Stream<List<Task>> get outTask => _taskController.stream;

  StreamController _actionProjectController = StreamController();
  StreamSink get fetchProjectTask => _actionProjectController.sink;

  //
  // Constructor
  //
  TaskBloc() {
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

  /// Delete task from the server and in the local database
  /// param: Task object
  Future deleteTaskAsync(Task task) async {
    if (task.runtimeType == RoutineTask) {
      await TaskRepository.get().deleteRoutineTaskAsync(task as RoutineTask);
    } else if (task.runtimeType == ProjectTask) {
      await TaskRepository.get().deleteProjectTaskAsync(task as ProjectTask);
    }
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

  void setAllSkillsByCreateProject(Skill skill) {
    if (skills[skills.indexOf(skill)].selected) {
      skills[skills.indexOf(skill)].selected = false;
    } else {
      skills[skills.indexOf(skill)].selected = true;
    }
  }

  void setTaskCreateSkill(Skill skill) {
    if (selectedSkills.where((p) => p.id == skill.id).isEmpty) {
      selectedSkills.add(skill);
    } else {
      selectedSkills.removeWhere((s) => s.id == skill.id);
    }
    _currentProjectTask.skills = selectedSkills;
  }

   Future getCreateSkills() async {
    if (selectedSkills != null) {
      _inSkill.add(selectedSkills);
    }
  }

  Future createTasksTomorrow() async {
    await TaskRepository.get().createRoutineTasksForTomorrow();
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

  Future getSelectedSkill() async {
    if (_currentProjectTask != null) {
      _inSkill.add(await SkillRepository.get()
          .getSelectedSkillsForProjectTaskById(_currentProjectTask.id));
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

  Future setProjectTaskSkill(ProjectTaskSkill projectTaskSkill) async {
    await TaskRepository.get().setProjectTaskSkill(projectTaskSkill);
  }

  List<Task> getTasksForTomorrow() {
    return _tasksTomorrow;
  }

  Future setTasksForTomorrow() async {
    _tasksTomorrow = await TaskRepository.get().getTasksForTomorrow();
  }

  Future startTasks(ProjectTask task) async {
    await TaskRepository.get().startTask(task);
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
