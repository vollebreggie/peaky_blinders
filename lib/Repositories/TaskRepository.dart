import 'dart:convert';

import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class TaskRepository extends BaseRepository {
  static final TaskRepository _repo = new TaskRepository._internal();
  LocalDatabase database;

  static TaskRepository get() {
    return _repo;
  }

  TaskRepository._internal() {
    database = LocalDatabase.get();
  }

  //TODO:: something will problably go wrong here now!
  void syncProjectTasks() async {
    //User user = await database.getLoggedInToken();
    http.Response response =
        await http.get(super.weburl + "api/ProjectTasks/list/1"); //userid
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectTask task in parsedResponse.body) {
        database.updateProjectTask(task);
      }
    }
  }

  Future createRoutineTasksForTomorrow(int userId) async {
    http.Response response =
        await http.get(super.weburl + "api/RoutineTasks/user/$userId"); //userid
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTask>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTask task in parsedResponse.body) {
        await database.updateRoutineTask(task);
      }
    }
  }

  Future<List<Task>> getTasksForTomorrow() async {
    return await database.getTasksForTommorow();
  }

  Future<List<Task>> getExistingTasksForToday() async {
    return await database.getExistingTasksForToday();
  }

  Future<List<Task>> getTasksForToday() async {
    return await database.getTasksForToday();
  }

  Future syncProjectTasksByMileStoneId(milestoneId) async {
    //User user = await database.getLoggedInToken();
    http.Response response = await http
        .get(super.weburl + "api/ProjectTasks/milestone/$milestoneId"); //userid
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectTask task in parsedResponse.body) {
        task.projectId = task.project.id;
        database.updateProjectTask(task);
      }
    }
  }

  Future completeProjectTask(int projectTaskId) async {
    http.Response response = await http
        .get(super.weburl + "api/ProjectTasks/completed/$projectTaskId")
        .catchError((resp) {});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateProjectTask(parsedResponse.body);
    }
  }

    Future completeRoutineTask(int routineTaskId) async {
    http.Response response = await http
        .get(super.weburl + "api/RoutineTasks/completed/$routineTaskId")
        .catchError((resp) {});
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTask>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateRoutineTask(parsedResponse.body);
    }
  }

  Future startTask(ProjectTask task) async {
    http.Response response =
        await http.get(super.weburl + "api/ProjectTasks/start/${task.id}");
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      database.updateProjectTask(parsedResponse.body);
    }
  }

  Future setProjectTaskTomorrow(ProjectTask task) async {
    http.Response response = await http
        .get(super.weburl + "api/ProjectTasks/setTomorrow/${task.id}");
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      database.updateProjectTask(parsedResponse.body);
    }
  }

  Future<Task> getNextTask() async {
    return await database.getNextTasksForToday();
  }

  Future updateProjectTask(ProjectTask projectTask) async {
    http.Response response = await http.put(
        super.weburl + "api/ProjectTasks/${projectTask.id}",
        body: jsonEncode(projectTask.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateProjectTask(parsedResponse.body);
    }
  }

  Future changePriorityProjectTasks(List<ProjectTask> tasks) async {
    MileStone milestone =
        new MileStone(id: 0, projectId: 0, place: 0, tasks: tasks);

    http.Response response = await http.put(
        super.weburl + "api/ProjectTasks/priority",
        body: jsonEncode(milestone.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectTask task in parsedResponse.body) {
        database.updateProjectTask(task);
      }
    }
  }

  Future changePriorityRoutineTasks(List<RoutineTask> tasks) async {
    List<dynamic> jsonRoutineTaskMap = [];
    for (RoutineTask task in tasks) {
      jsonRoutineTaskMap.add(task.toMap());
    }

      http.Response response = await http.put(
        super.weburl + "api/RoutineTasks/priority",
        body: jsonEncode(jsonRoutineTaskMap),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTask>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTask task in parsedResponse.body) {
        database.updateRoutineTask(task);
      }
    }
  }

  Future createProjectTask(ProjectTask projectTask) async {
    int id = projectTask.project.id;
    projectTask.project = null;
    projectTask.id = 0;
    projectTask.completed = null;

    http.Response response = await http.post(
        super.weburl + "api/ProjectTasks/$id",
        body: jsonEncode(projectTask.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      database.updateProjectTask(parsedResponse.body);
    }
  }

  Future createProjectTaskToday(ProjectTask projectTask) async {
    projectTask.project = null;
    projectTask.id = 0;
    projectTask.completed = null;

    http.Response response = await http.post(super.weburl + "api/ProjectTasks",
        body: jsonEncode(projectTask.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<ProjectTask>(response, false);

    if (parsedResponse.isOk()) {
      database.updateProjectTask(parsedResponse.body);
    }
  }

  Future createProjectTaskByMilestone(ProjectTask projectTask) async {
    http.Response response = await http.post(
        super.weburl + "api/ProjectTasks/milestone",
        body: jsonEncode(projectTask.toMapWithoutId()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
  }

  Future<List<ProjectTask>> getProjectTasks() async {
    return await database.getProjectTasks();
  }

  Future<List<ProjectTask>> getProjectTasksWithCompleted() async {
    return await database.getProjectTasksWithCompleted();
  }

  Future<List<ProjectTask>> getProjectTasksByProjectId(int projectId) async {
    return await database.getProjectTasksByProjectId(projectId);
  }

  Future<List<ProjectTask>> getProjectTasksByMilestoneId(
      int milestoneId) async {
    return await database.getProjectTasksByMilestoneId(milestoneId);
  }
}
