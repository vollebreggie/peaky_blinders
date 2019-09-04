import 'dart:convert';

import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';

class Master {
  int id, userId;
  String name;
  User user;
  List<Reason> reasons;
  List<Problem> problems;

  Master(
      {this.id,
      this.userId,
      this.name,
      this.user,
      this.reasons,
      this.problems});

  static List<dynamic> reasonsToMap(List<Reason> reasons) {
    List<dynamic> jsonReasonsMap = [];
    for (var reason in reasons) {
      jsonReasonsMap.add(reason.toMap());
    }
    return jsonReasonsMap;
  }

  static List<Problem> problemFromMap(List<dynamic> list) {
    List<Problem> problems = [];
    for (var problem in list) {
      problems.add(Problem.fromMap(problem));
    }
    return problems;
  }

  static List<dynamic> problemsToMap(List<Problem> problems) {
    List<dynamic> jsonProblemsMap = [];
    for (var problem in problems) {
      jsonProblemsMap.add(problem.toMap());
    }
    return jsonProblemsMap;
  }

  static List<Reason> reasonsFromMap(List<dynamic> list) {
    List<Reason> reasons = [];
    for (var reason in list) {
      reasons.add(Reason.fromMap(reason));
    }
    return reasons;
  }

  factory Master.fromMap(Map<String, dynamic> json) => new Master(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      user: json["user"] != null ? User.fromMap(json["user"]) : null,
      reasons: json["reasons"] != null ? reasonsFromMap(json["reasons"]) : null,
      problems:
          json["problems"] != null ? problemFromMap(json["problems"]) : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "name": name,
        "user": user != null ? user.toMap() : null,
        "reasons": reasons != null ? reasonsToMap(reasons) : null,
        "problems": problems != null ? problemsToMap(problems) : null
      };
}
