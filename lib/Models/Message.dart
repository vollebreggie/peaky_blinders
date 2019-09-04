import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';

class Message {
  int id, userId;
  User user;
  Log log;
  System system;

  Message({id, title, userId, log, system});

  factory Message.fromMap(Map<String, dynamic> map) => new Message(
      id: map["id"],
      userId: map["userId"],
      log: Log.fromMap(map["log"]),
      system: System.fromMap(map["system"]));

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "log": log.toMap(),
      "system": system.toMap()
    };
  }
}
