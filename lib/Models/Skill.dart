import 'dart:convert';

import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/User.dart';

class Skill {
  int id, userId, masterId, reasonId, problemId, place, points;
  String title, description,imagePathServer;
  User user;
  Master master;
  bool selected;

  Reason reason;
  Problem problem;

  Skill(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.user,
      this.masterId,
      this.master,
      this.problemId,
      this.problem,
      this.reasonId,
      this.reason,
      this.place,
      this.imagePathServer,
      this.selected,
      this.points});

  factory Skill.fromMap(Map<String, dynamic> json) => new Skill(
      id: json["id"],
      userId: json["userId"],
      masterId: json["masterId"] != "null" ? json["masterId"] : null,
      title: json["title"],
      place: json["place"],
      points: json["points"],
      imagePathServer: json["imagePath"],
      description: json["description"],
      user: json["user"] != null ? User.fromMap(json["user"]) : null,
      master: json["master"] != null ? Master.fromMap(json["master"]) : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "title": title,
        "points": points,
        "imagePath": imagePathServer,
        "place": place != null ? place : 0,
        "description": description,
        "user": user != null ? user.toMap() : null,
        "masterId": masterId,
        "master": master != null ? master.toMap() : null,
        "reasonId": reasonId,
        "reason": reason != null ? reason.toMap() : null,
        "problemId": problemId,
        "problem": problem != null ? problem.toMap() : null
      };
}
