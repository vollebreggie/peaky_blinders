import 'dart:convert';

import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';

class Problem {
  int id, userId, masterId, place, points;
  String name, description, imagePath;
  User user;
  Master master;
  List<Skill> skills;
  bool selected;

  Problem(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.imagePath,
      this.user,
      this.masterId,
      this.master,
      this.skills,
      this.place,
      this.points});

  static List<dynamic> skillsToMap(List<Skill> skills) {
    List<dynamic> jsonSkillsMap = [];
    for (var skill in skills) {
      jsonSkillsMap.add(skill.toMap());
    }
    return jsonSkillsMap;
  }

  static List<Skill> skillsFromMap(List<dynamic> list) {
    List<Skill> skills = [];
    for (var skill in list) {
      skills.add(Skill.fromMap(skill));
    }
    return skills;
  }

  factory Problem.fromMap(Map<String, dynamic> json) => new Problem(
      id: json["id"],
      userId: json["userId"],
      masterId: json["masterId"] != "null" ? json["masterId"] : null,
      name: json["name"],
      description: json["description"],
      imagePath: json["imagePath"],
      place: json["place"],
      points: json["points"],
      user: json["user"] != null ? User.fromMap(json["user"]) : null,
      master: json["master"] != null ? Master.fromMap(json["master"]) : null,
      skills: json["skills"] != null ? skillsFromMap(json["skills"]) : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "name": name,
        "description": description,
        "imagePath": imagePath,
        "points": points,
        "place": place != null ? place : 0,
        "user": user != null ? user.toMap() : null,
        "masterId": masterId,
        "master": master != null ? master.toMap() : null,
        "skills": skills != null ? skillsToMap(skills) : null,
      };
}
