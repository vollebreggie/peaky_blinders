import 'dart:convert';

import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/User.dart';

class Reason {
  int id, userId, masterId;
  String name;
  User user;
  Master master;

  Reason(
      {this.id, this.userId, this.name, this.user, this.masterId, this.master});

  factory Reason.fromMap(Map<String, dynamic> json) => new Reason(
      id: json["id"],
      userId: json["userId"],
      masterId: json["masterId"],
      name: json["name"],
      user: json["user"] != null ? User.fromMap(json["user"]) : null,
      master: json["master"] != null ? Master.fromMap(json["master"]) : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "name": name,
        "user": user != null ? user.toMap() : null,
        "masterId": masterId,
        "master": master != null ? master.toMap() : null
      };
}
