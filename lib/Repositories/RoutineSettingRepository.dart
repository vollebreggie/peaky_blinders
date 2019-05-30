import 'dart:convert';

import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class RoutineSettingRepository extends BaseRepository {
  static final RoutineSettingRepository _repo =
      new RoutineSettingRepository._internal();
  LocalDatabase database;

  static RoutineSettingRepository get() {
    return _repo;
  }

  RoutineSettingRepository._internal() {
    database = LocalDatabase.get();
  }

Future syncProjectSettings() async {
    //User user = await database.getLoggedInToken();
    http.Response response =
        await http.get(super.weburl + "api/RoutineTaskSettings"); //userid
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSetting task in parsedResponse.body) {
        database.updateRoutineSetting(task);
      }
    }
  }

  Future completeRoutineTask(int taskId) async {
    http.Response response = await http
        .get(super.weburl + "api/RoutineTaskSettings/completed/$taskId")
        .catchError((resp) {});
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateRoutineSetting(parsedResponse.body);
    }
  }

  Future updateRoutineTask(RoutineTaskSetting routineTaskSetting) async {
    http.Response response = await http.put(
        super.weburl + "api/RoutineTaskSettings/${routineTaskSetting.id}",
        body: jsonEncode(routineTaskSetting.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateRoutineSetting(parsedResponse.body);
    }
  }

  Future changePriorityTasks(List<RoutineTaskSetting> tasks) async {

    List<dynamic> jsonTasksMap = [];
    for (var task in tasks) {
      jsonTasksMap.add(task.toMap());
    }
  
    //String json = jsonEncode(jsonTasksMap);
    http.Response response = await http.put(
        super.weburl + "api/RoutineTaskSettings/priority",
        body: jsonEncode(jsonTasksMap),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSetting task in parsedResponse.body) {
        database.updateRoutineSetting(task);
      }
    }
  }

  Future createRoutineTask(RoutineTaskSetting routineTaskSetting) async {
    http.Response response = await http.post(super.weburl + "api/RoutineTaskSettings",
        body: jsonEncode(routineTaskSetting.toMap()),
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, false);

    if (parsedResponse.isOk()) {
      database.updateRoutineSetting(parsedResponse.body);
    }
  }

  Future<List<RoutineTaskSetting>> getRoutineSettings() async {
    return await database.getRoutineSettings();
  }
}
