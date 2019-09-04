import 'dart:convert';
import 'dart:io';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Message.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class PersonalRepository extends BaseRepository {
  static final PersonalRepository _repo = new PersonalRepository._internal();
  LocalDatabase database;
  User user;
  static PersonalRepository get() {
    return _repo;
  }

  PersonalRepository._internal() {
    database = LocalDatabase.get();
  }

  Future sendIntroData(User user) async {
    String jsonMap = jsonEncode(user.toMap());
    http.Response response = await http
        .post(super.weburl + "api/accounts/introData", body: jsonMap, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<User>(response, false);

    if (parsedResponse.isOk()) {
      User user = parsedResponse.body;
      database.updateLoggedInUser(user);
      for (Master master in user.masters) {
        database.updateMaster(master);
        for (Problem problem in master.problems) {
          database.updateProblem(problem);
          for (Skill skill in problem.skills) {
            database.updateSkill(skill);
          }
        }
        for (Reason reason in master.reasons) {
          database.updateReason(reason);
        }
      }

      for (Problem problem in user.problems) {
        database.updateProblem(problem);
        for (Skill skill in problem.skills) {
          database.updateSkill(skill);
        }
      }

      print("done");
    }
  }
}
