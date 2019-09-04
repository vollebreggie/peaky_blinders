import 'dart:convert';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/Message.dart';
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

  Message createErrorMessage() {
    Message message = new Message();
    return message;
  }

  System getSystem() {
    return new System(
        id: 0,
        name: "PeakyApp",
        version: "0.0.1",
        releaseDate: DateTime.parse("2019-05-31 00:00:00"));
  }

  Future sendErrorMessage(String description, String stacktrace) async {
    Log log = new Log(id: 0, description: description, stacktrace: stacktrace, solved: false);

   Message message = new Message();
   message.id = 0;
   message.log = log;
   message.system = getSystem();
   message.userId = user != null ? user.id : 1;
        

    http.Response response = await http.post(super.weburl + "api/Messages",
        body: jsonEncode(message.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
    print(response);
  }

  Future sendError(Message message) async {
    String jsonMap = jsonEncode(message.toMap());
    await http.post(super.weburl + "api/Message",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
  }
}
