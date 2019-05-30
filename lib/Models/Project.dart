import 'dart:core';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Models/UserProject.dart';

@JsonSerializable()
class Project {
  static final db_id = "id";
  static final db_title = "title";
  static final db_description = "description";
  static final db_completed_points = "completedPoints";
  static final db_total_points = "totalPoints";
  static final db_image_local = "image_local";
  static final db_image_server = "imagePath";
  static final db_last_updated = "lastUpdated";
  static final db_started = "started";
  static final db_completed = "completed";
  static final db_enddate = "enddate";
  static final db_priority = "priority";

  int id, completedPoints, totalPoints;
  DateTime lastUpdated, completed, started;
  String title, description, priority, imagePathServer, imagePathLocal;
  List<ProjectTask> tasks;
  List<User> users;
  List<UserProject> userProject;
  List<MileStone> milestones;

  Project(
      {this.id,
      this.title,
      this.description,
      this.totalPoints,
      this.completedPoints,
      this.priority,
      this.imagePathServer,
      this.imagePathLocal,
      this.completed,
      this.started,
      this.lastUpdated,
      this.userProject,
      this.milestones});

  Project.fromMap(Map<String, dynamic> map)
      : this(
            title: map[db_title],
            description: map[db_description],
            id: map[db_id],
            //imagePathLocal: map[db_image_local],
            imagePathServer: map[db_image_server],
            completedPoints: map["completedPoints"],
            totalPoints: map["totalPoints"],
            started: map[db_started] != null
                ? DateTime.tryParse(map[db_started])
                : null,
            completed: map[db_completed] != null
                ? DateTime.tryParse(map[db_completed])
                : null,
            lastUpdated: map["lastUpdated"] != null
                ? DateTime.tryParse(map["lastUpdated"])
                : null,
            priority: map[db_priority],
            milestones: map["mileStones"] != null ? milestonesFromMap(map["mileStones"]) : null,
            userProject: map["userProjects"] != null
                ? userProjectsFromMaps(map["userProjects"])
                : null);

  double getProgress() {
    if (totalPoints != null && totalPoints != 0 && completedPoints != null) {
      return completedPoints / totalPoints;
    } else {
      return 0.0;
    }
  }

  int getCompletedTasks() {
    if (tasks == null) {
      return 0;
    }

    // List<ProjectTask> tempTasks = tasks.where((t) => t.completed != null);

    return 0;
  }

  static List<UserProject> userProjectsFromMaps(List<dynamic> list) {
    List<UserProject> newList = [];
    for (dynamic jsonObject in list) {
      newList.add(UserProject.fromMap(jsonObject));
    }
    return newList;
  }

  static List<MileStone> milestonesFromMap(List<dynamic> list) {
    List<MileStone> milestones = [];
    for (var milestone in list) {
      milestones.add(MileStone.fromMap(milestone));
    }
    return milestones;
  }

  static List<dynamic> milestoneToMap(List<MileStone> milestones) {
    //TODO:: map tasks.
    List<dynamic> jsonMilestonesMap = [];
    for (var milestone in milestones) {
      jsonMilestonesMap.add(milestone.toMap());
    }
    return jsonMilestonesMap;
  }

  static List<dynamic> milestoneWithoutIdToMap(List<MileStone> milestones) {
    //TODO:: map tasks.
    List<dynamic> jsonMilestonesMap = [];
    for (var milestone in milestones) {
      jsonMilestonesMap.add(milestone.toMapWithoutId());
    }
    return jsonMilestonesMap;
  }

  static List<dynamic> usersToMap(List<User> users) {
    List<dynamic> jsonUsersMap = [];
    for (var user in users) {
      jsonUsersMap.add(user.toMap());
    }
    return jsonUsersMap;
  }

  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_description: description,
      db_id: id,
      "completedPoints": completedPoints,
      "totalPoints": totalPoints,
      "lastUpdated": lastUpdated != null ? lastUpdated.toIso8601String() : null,
      db_image_server: imagePathServer,
      db_started: started != null ? started.toIso8601String() : null,
      db_completed: completed != null ? completed.toIso8601String() : null,
      db_priority: priority,
      "milestones": milestoneToMap(milestones),
      "users": usersToMap(users)
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      db_title: title,
      db_description: description,
      "completedPoints": completedPoints,
      "totalPoints": totalPoints,
      "lastUpdated": lastUpdated != null ? lastUpdated.toIso8601String() : null,
      db_image_server: imagePathServer,
      db_started: started != null ? started.toIso8601String() : null,
      db_completed: completed != null ? completed.toIso8601String() : null,
      db_priority: priority,
      "milestones": milestoneWithoutIdToMap(milestones),
      "users": users != null ? usersToMap(users) : null
    };
  }
}
