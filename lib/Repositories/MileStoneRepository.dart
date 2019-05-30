import 'dart:convert';

import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/WebSocketMessage.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';

class MileStoneRepository extends BaseRepository {
  static final MileStoneRepository _repo = new MileStoneRepository._internal();
  LocalDatabase database;

  static MileStoneRepository get() {
    return _repo;
  }

  MileStoneRepository._internal() {
    database = LocalDatabase.get();
  }

  Future syncMilestonesByProjectId(projectId) async {
    //User user = await database.getLoggedInToken();
    http.Response response =
        await http.get(super.weburl + "api/Milestones/project/$projectId");
    ParsedResponse parsedResponse =
        interceptResponse<MileStone>(response, true);

    if (parsedResponse.isOk()) {
      for (MileStone milestone in parsedResponse.body) {
        database.updateMilestone(milestone);
        await TaskRepository.get().syncProjectTasksByMileStoneId(milestone.id);
      }
    }
  }

  Future syncMilestone(milestoneId) async {
    http.Response response =
        await http.get(super.weburl + "api/Milestones/$milestoneId");
    ParsedResponse parsedResponse =
        interceptResponse<MileStone>(response, false);

    if (parsedResponse.isOk()) {
      MileStone milestone = parsedResponse.body;
        database.updateMilestone(milestone);
      
    }
  }

  Future<List<MileStone>> getMilestonesByProjectId(projectId) async {
    return await database.getMilestonesByProjectId(projectId);
  }

  Future createMilestone(MileStone milestone) async {
    Map<String, dynamic> map = milestone.toMapWithoutId();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.post(super.weburl + "api/Milestones",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    Map<String, dynamic> mapMilestone = json.decode(response.body);

    //TODO::

    /// await postUserToProject(user.id, mapProject["id"]);
  }

  Future updateMilestones(List<MileStone> milestones) async {
    for (MileStone milestone in milestones) {
      if (milestone.id == null) {
        String jsonUpdateMap = jsonEncode(milestone.toMapWithoutId());
        http.Response createResponse = await http.post(
            super.weburl + "api/Milestones",
            body: jsonUpdateMap,
            headers: {
              "Content-Type": "application/json"
            }).catchError((resp) {});
      } else {
        String jsonCreateMap = jsonEncode(milestone.toMap());
        http.Response updateResponse = await http.put(
            super.weburl + "api/Milestones/${milestone.id}",
            body: jsonCreateMap,
            headers: {
              "Content-Type": "application/json"
            }).catchError((resp) {});
      }
    }

    //  Map<String, dynamic> mapMilestone = json.decode(response.body);

    //TODO::

    /// await postUserToProject(user.id, mapProject["id"]);
  }
}
