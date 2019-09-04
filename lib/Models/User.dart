import 'dart:convert';

import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/Token.dart';

User clientFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String clientToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int id, configured, amountOfSkills;
  String identiyId, firstName, lastName, image;
  Token token;
  List<Problem> problems;
  List<Master> masters;
  List<Skill> skills;
  bool selected;

  User(
      {this.id,
      this.identiyId,
      this.firstName,
      this.lastName,
      this.token,
      this.image,
      this.selected,
      this.configured,
      this.problems,
      this.skills,
      this.masters,
      this.amountOfSkills});

  static List<Skill> skillsFromMap(List<dynamic> list) {
    List<Skill> skills = [];
    for (var skill in list) {
      skills.add(Skill.fromMap(skill));
    }
    return skills;
  }

  static List<Master> mastersFromMap(List<dynamic> list) {
    List<Master> masters = [];
    for (var master in list) {
      masters.add(Master.fromMap(master));
    }
    return masters;
  }

  static List<Problem> problemFromMap(List<dynamic> list) {
    List<Problem> problems = [];
    for (var problem in list) {
      problems.add(Problem.fromMap(problem));
    }
    return problems;
  }

  ///TODO:: this needs refactoring
  static List<dynamic> skillsToMap(List<Skill> skills) {
    List<dynamic> jsonSkillsMap = [];
    for (var skill in skills) {
      jsonSkillsMap.add(skill.toMap());
    }
    return jsonSkillsMap;
  }

  static List<dynamic> mastersToMap(List<Master> masters) {
    List<dynamic> jsonMastersMap = [];
    for (var master in masters) {
      jsonMastersMap.add(master.toMap());
    }
    return jsonMastersMap;
  }

  static List<dynamic> problemsToMap(List<Problem> problems) {
    List<dynamic> jsonProblemsMap = [];
    for (var problem in problems) {
      jsonProblemsMap.add(problem.toMap());
    }
    return jsonProblemsMap;
  }

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json["id"],
      identiyId: json["identiyId"],
      firstName: json["firstname"],
      amountOfSkills: json["amountOfSkills"],
      image: json["image"],
      configured: json["configured"],
      masters: json["masters"] != null ? mastersFromMap(json["masters"]) : null,
      problems:
          json["problems"] != null ? problemFromMap(json["problems"]) : null,
      skills: json["skills"] != null ? skillsFromMap(json["skills"]) : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "identiyId": identiyId,
        "firstname": firstName,
        "image": image,
        "amountOfSkills" : amountOfSkills,
        "configured": configured,
        "problems": problems != null ? problemsToMap(problems) : null,
        "skills": skills != null ? skillsToMap(skills) : null,
        "masters": masters != null ? mastersToMap(masters) : null
      };
}
