import 'dart:convert';

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
  int id;
  String identiyId, firstName, lastName, image;
  Token token;
  bool selected;

  User({
    this.id,
    this.identiyId,
    this.firstName,
    this.lastName,
    this.token,
    this.image,
    this.selected
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json["id"],
        identiyId: json["identiyId"],
        firstName: json["firstname"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "identiyId": identiyId,
        "firstname": firstName,
        "image": image,
      };
}