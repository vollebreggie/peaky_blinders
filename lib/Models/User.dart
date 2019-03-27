import 'dart:convert';

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
  String firstName;
  String lastName;


  User({
    this.id,
    this.firstName,
    this.lastName,

  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}