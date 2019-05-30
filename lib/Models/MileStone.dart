import 'package:peaky_blinders/Models/ProjectTask.dart';

class MileStone {
  int id, place, projectId;
  List<ProjectTask> tasks;
  String image, title;
  DateTime startDate, endDate, completed;

  MileStone(
      {this.id,
      this.tasks,
      this.title,
      this.image,
      this.place,
      this.startDate,
      this.endDate,
      this.completed,
      this.projectId});

  MileStone.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            title: map["title"],
            image: map["image"],
            place: map["place"],
            projectId: map["projectId"],
            startDate: map["startDate"] != null
                ? DateTime.tryParse(map["startDate"])
                : null,
            endDate: map["endDate"] != null
                ? DateTime.tryParse(map["endDate"])
                : null,
            completed: map["completed"],
            tasks: map["projectTasks"] != null ? tasksFromMap(map["projectTasks"]) : []);

static List<ProjectTask> tasksFromMap(List<dynamic> jsonTasksMap) {
    List<ProjectTask> tasks = [];
    for (var task in jsonTasksMap) {
      tasks.add(ProjectTask.fromMap(task));
    }
    return tasks;
  }

  static List<dynamic> tasksToMap(List<ProjectTask> tasks) {
    //TODO:: map tasks.
    List<dynamic> jsonTasksMap = [];
    for (var task in tasks) {
      jsonTasksMap.add(task.toMap());
    }
    return jsonTasksMap;
  }

  static List<dynamic> tasksWithoutIdToMap(List<ProjectTask> tasks) {
    //TODO:: map tasks.
    List<dynamic> jsonTasksMap = [];
    for (var task in tasks) {
      jsonTasksMap.add(task.toMapWithoutId());
    }
    return jsonTasksMap;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "startDate": startDate != null ? startDate.toIso8601String() : null,
      "endDate": endDate != null ? endDate.toIso8601String() : null,
      "place": place,
      "projectId": projectId,
      "projectTasks": tasks != null ? tasksToMap(tasks) : null
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      "title": title,
      "startDate": startDate != null ? startDate.toIso8601String() : null,
      "endDate": endDate != null ? endDate.toIso8601String() : null,
      "place": place,
      //"projectId": projectId,
      "projectTasks": tasks != null ? tasksWithoutIdToMap(tasks) : null
    };
  }

  int getPoints() {
    num sum = 0;
    tasks.forEach((t) {
      sum += t.points;
    });
    return sum;
  }
}
