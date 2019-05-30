import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Models/User.dart';

ProjectTask projectTaskFromJson(String str) {
  final jsonData = json.decode(str);
  return ProjectTask.fromMap(jsonData);
}

String projectTaskToJson(ProjectTask data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class ProjectTask extends Task {
  static final db_projectId = "projectId";
  static final db_milestoneId = "milestoneId";
  static final db_userId = "userId";
  static final db_priority = "priority";

  int projectId, milestoneId, userId;

  String priority;
  Project project;
  User user;
  
  ProjectTask({
    id,
    title,
    description,
    started,
    completed,
    this.projectId,
    this.project,
    points,
    this.priority,
    this.user,
    this.userId,
    place,
    this.milestoneId

  }) : super(id: id, title: title, description: description, started: started, completed: completed, place: place, points: points);

  factory ProjectTask.fromMap(Map<String, dynamic> map) => new ProjectTask(
    title: map[Task.db_title],
    description: map[Task.db_description],
    id: map[Task.db_id],
    started: map[Task.db_started] != null ? DateTime.tryParse(map[Task.db_started]) : null,
    projectId: map[db_projectId],
    userId: map[db_userId],
    milestoneId: map[db_milestoneId],
    completed: map[Task.db_completed] != null ? DateTime.tryParse(map[Task.db_completed]) : null,
    priority: map[db_priority],
    points: map[Task.db_points],
    place: map[Task.db_place],
    project: map["project"] != null ? Project.fromMap(map["project"]) : null
  );

  Map<String, dynamic> toMap() {
    return {
      Task.db_title: title,
      Task.db_description: description,
      Task.db_id: id,
      Task.db_started: started != null ? started.toIso8601String() : null,
      Task.db_completed: completed != null ? completed.toIso8601String() : null,
      Task.db_points: points,
      db_priority: priority,
      Task.db_place: place,
      db_milestoneId: milestoneId,
      db_userId: userId,
      "user": user != null ? user.toMap() : null,
      "projectId": projectId,
    };
  }

    Map<String, dynamic> toMapWithoutId() {
    return {
      Task.db_title: title,
      Task.db_description: description,
      Task.db_started: started != null ? started.toIso8601String() : null,
      Task.db_completed: completed != null ? completed.toIso8601String() : null,
      Task.db_points: points,
      db_priority: priority,
      //db_milestoneId: milestoneId,
      Task.db_place: place,
      db_userId: user.id,
      "projectId": 0,
    };
  }

}