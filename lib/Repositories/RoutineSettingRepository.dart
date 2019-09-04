import 'dart:convert';
import 'dart:io';

import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class RoutineSettingRepository extends BaseRepository {
  static final RoutineSettingRepository _repo =
      new RoutineSettingRepository._internal();

  static RoutineSettingRepository get() {
    return _repo;
  }

  RoutineSettingRepository._internal() {
    database = LocalDatabase.get();
  }

  Future syncProjectSettings() async {
    //User user = await database.getLoggedInToken();
    http.Response response = await http
        .get(super.weburl + "api/RoutineTaskSettings", headers: {
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }); //userid
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSetting task in parsedResponse.body) {
        database.updateRoutineSetting(task);
      }
    }
  }

  Future completeRoutineTask(int taskId) async {
    http.Response response = await http.get(
        super.weburl + "api/RoutineTaskSettings/completed/$taskId",
        headers: {
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {});
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
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {});

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
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {
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

  Future syncRoutineSettingSkill(int routineSettingId) async {
    http.Response response = await http
        .get(super.weburl + "api/Skills/routine/$routineSettingId", headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSettingSkill>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSettingSkill skill in parsedResponse.body) {
        await database.updateRoutineTaskSettingSkill(skill);
      }
    }
  }

  Future<List<Skill>> getAllSkillsForRoutineTaskSettingById(routineSettingId) async {
    return await database.getAllSkillsForRoutineTaskSettingById(routineSettingId);
  }

  Future createRoutineTask(RoutineTaskSetting routineTaskSetting) async {
    http.Response response = await http.post(
        super.weburl + "api/RoutineTaskSettings",
        body: jsonEncode(routineTaskSetting.toMap()),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {
      print(resp.toString());
    });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateRoutineSetting(parsedResponse.body);
      await syncRoutineSettingSkill((parsedResponse.body as RoutineTaskSetting).id);
    }
  }

  Future<List<RoutineTaskSetting>> getRoutineSettings() async {
    return await database.getRoutineSettings();
  }

  //Deletes the routineTaskSetting from the server and in the local database
  //param: routineTaskSettings object
  //returns: nothing
  Future deleteRoutineSetting(RoutineTaskSetting routineTaskSetting) async {
    http.Response response = await http.delete(
        super.weburl + "api/RoutineTaskSettings/${routineTaskSetting.id}",
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        });

    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSetting>(response, false);

    //TODO:: what to do when the response is not ok?
    if (parsedResponse.isOk()) {
      await database.deleteRoutineTaskSettingById(routineTaskSetting.id);
    }
  }

  Future setRoutineTaskSettingSkill(
      RoutineTaskSettingSkill routineTaskSettingSkill) async {
    http.Response response = await http.get(
        super.weburl +
            "api/RoutineTaskSettings/skill/${routineTaskSettingSkill.routineTaskSettingId}/${routineTaskSettingSkill.skillId}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSettingSkill>(response, false);

    if (parsedResponse.isOk()) {
      if ((parsedResponse.body as RoutineTaskSettingSkill).skillId == 0) {
        await database.deleteRoutineTaskSettingSkillById(
            (parsedResponse.body as RoutineTaskSettingSkill).id);
      } else {
        await database.updateRoutineTaskSettingSkill(parsedResponse.body);
      }
    }
  }
}
