import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';

class ErrorLog {
  int id, userId, statusCode;
  User user;
  String stackTrace, message, innerException, typeException;
  System systemInfo;

  ErrorLog({id, statusCode, stackTrace, innerException, typeException, userId, log, systemInfo});

  factory ErrorLog.fromMap(Map<String, dynamic> map) => new ErrorLog(
      id: map["id"],
      userId: map["userId"],
      innerException: map["innerException"],
      typeException: map["typeException"],
      stackTrace: map["stackTrace"],
      systemInfo: System.fromMap(map["systemInfo"]));

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "statusCode": statusCode,
      "stackTrace": stackTrace,
      "message": message,
      "innerException": innerException,
      "typeException": typeException,
      "systemInfo": systemInfo.toMap()
    };
  }
}
