import 'dart:convert';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/ErrorLog.dart';
import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;

class ErrorRepository extends BaseRepository {
  static final ErrorRepository _repo = new ErrorRepository._internal();
  LocalDatabase database;
  User user;
  static ErrorRepository get() {
    return _repo;
  }

  ErrorRepository._internal() {
    database = LocalDatabase.get();
  }

  ErrorLog createErrorMessage() {
    ErrorLog errorLog = new ErrorLog();
    return errorLog;
  }

  System getSystem() {
    return new System(
        id: 0,
        name: "PeakyApp",
        version: "1.0.0",
        releaseDate: DateTime.now());
  }

  Future sendErrorMessage(String description, String stacktrace) async {

   ErrorLog errorLog = new ErrorLog();
   errorLog.id = 0;
   errorLog.message = description;
   errorLog.stackTrace = stacktrace;
   errorLog.systemInfo = getSystem();
   errorLog.userId = user != null ? user.id : 1;
        

    http.Response response = await http.post(super.weburl + "api/ErrorLog",
        body: jsonEncode(errorLog.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
    print(response);
  }

  Future sendError(ErrorLog errorLog) async {
    String jsonMap = jsonEncode(errorLog.toMap());
    await http.post(super.weburl + "api/Message",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
  }
}
