import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Message.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/ProjectTaskSkill.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class SkillRepository extends BaseRepository {
  static final SkillRepository _repo = new SkillRepository._internal();
  LocalDatabase database;
  User user;
  static SkillRepository get() {
    return _repo;
  }

  SkillRepository._internal() {
    database = LocalDatabase.get();
  }

  Future<List<Skill>> getSkills() async {
    return await database.getSkills();
  }

  Future<String> getImageSkill(Skill skill) async {
    return await database.getImageSkill(skill);
  }

  Future removeSkill(Skill skill) async {
    http.Response response = await http.delete(
        super.weburl + "api/Skills/${skill.id}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, false);

    if (parsedResponse.isOk()) {
      await database.deleteSkillByIdAsync((parsedResponse.body as Skill).id);
    }
  }

  Future syncSkillsForTask(int projectId) async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/task/${projectId}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTaskSkill>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectTaskSkill projectTaskSkill in parsedResponse.body) {
        await database.updateProjectTaskSkill(projectTaskSkill);
      }
    }
  }

  Future syncSkillsForRoutineSetting(int routineId) async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/routine/${routineId}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSettingSkill>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSettingSkill routineTaskSettingSkill
          in parsedResponse.body) {
        await database.updateRoutineTaskSettingSkill(routineTaskSettingSkill);
      }
    }
  }

  Future createSkill(Skill skill) async {
    http.Response response = await http.post(super.weburl + "api/Skills",
        body: jsonEncode(skill.toMap()),
        headers: {
          HttpHeaders.authorizationHeader: await getAuthHeader(),
          "Content-Type": "application/json",
        });
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateSkill(parsedResponse.body);
    }
  }

  Future postSkillWithImage(File image, Skill skill) async {
    http.Response response = await http.post(super.weburl + "api/Skills",
        body: jsonEncode(skill.toMap()),
        headers: {
          HttpHeaders.authorizationHeader: await getAuthHeader(),
          "Content-Type": "application/json",
        });
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, false);

    if (parsedResponse.isOk()) {
      if (image != null) {
        await uploadImageSkill(image, parsedResponse.body);
      } else if (image == null) {
        await database.updateSkill(parsedResponse.body);
      }
    }
  }

  Future<List<Skill>> getSelectedSkillsForProjectTaskById(
      int projectTaskId) async {
    return await database.getSelectedSkillsByProjectTaskId(projectTaskId);
  }

  Future<Skill> uploadImageSkill(File imageFile, Skill skill) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/Skills/image/${skill.id}");

    // create multipart request
    var request = new http.MultipartRequest(
      "POST",
      uri,
    );

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();

    // listen for response
    await database.updateSkill(Skill.fromMap(
        json.decode(await response.stream.transform(utf8.decoder).first)));
  }

  Future<List<Skill>> getSelectedSkillsForRoutineTaskSettingById(
      int routineTaskId) async {
    return await database
        .getSelectedSkillsByRoutineTaskSettingId(routineTaskId);
  }

  Future<List<Skill>> getSkillsForGraph(int amount) async {
    return await database.getSkillsForGraph(amount);
  }

  Future<List<Skill>> getUnselectedSkills() async {
    return await database.getUnselectedSkills();
  }

  Future<List<Skill>> getAllSkillsBasedOnSelected(
      List<Skill> selectedSkills) async {
    List<Skill> skills = await database.getSkills();
    for (Skill skill in skills) {
      if (selectedSkills.where((p) => p.id == skill.id).length != 0) {
        skills[skills.indexWhere((s) => s.id == skill.id)].selected = true;
      } else {
        skills[skills.indexWhere((s) => s.id == skill.id)].selected = false;
      }
    }
    return skills;
  }

  Future<List<Skill>> getAllSkillsForRoutineTaskSettingById(
      int routineTaskId) async {
    return await database.getAllSkillsForRoutineTaskSettingById(routineTaskId);
  }

  Future<List<Skill>> getAllSkillsForProjectTaskById(int projectTaskId) async {
    return await database.getAllSkillsForProjectTaskById(projectTaskId);
  }

  Future changePrioritySkills(List<Skill> skills) async {
    User user =
        new User(id: 0, configured: 0, amountOfSkills: 0, skills: skills);

    String json = jsonEncode(user.toMap());
    http.Response response =
        await http.put(super.weburl + "api/Skills", body: json, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    });
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, true);

    if (parsedResponse.isOk()) {
      for (Skill skill in parsedResponse.body) {
        await database.updateSkill(skill);
      }
    }
  }

  Future updateSkillWithImage(Skill skill, File image) async {
    http.Response response = await http.put(
        super.weburl + "api/Skills/${skill.id}",
        body: jsonEncode(skill.toMap()),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        });
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, false);

    if (parsedResponse.isOk()) {
      await uploadImageSkill(image, skill);
    }
  }

  Future updateSkill(Skill skill) async {
    http.Response response = await http.put(
        super.weburl + "api/Skills/${skill.id}",
        body: jsonEncode(skill.toMap()),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        });
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateSkill(parsedResponse.body);
    }
  }

  Future syncSkills() async {
    http.Response response = await http.get(super.weburl + "api/Skills",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, true);

    if (parsedResponse.isOk()) {
      for (Skill skill in parsedResponse.body) {
        await database.updateSkill(skill);
      }
    }
  }

  Future syncSkillsRoutines() async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/routines",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<RoutineTaskSettingSkill>(response, true);

    if (parsedResponse.isOk()) {
      for (RoutineTaskSettingSkill routineTaskSettingSkill
          in parsedResponse.body) {
        await database.updateSkill(routineTaskSettingSkill.skill);
        await database.updateRoutineTaskSettingSkill(routineTaskSettingSkill);
      }
    }
  }

  Future syncSkillsProjectTasks() async {
    try {
      http.Response response = await http.get(
          super.weburl + "api/Skills/projectTasks",
          headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
      print("sup");
      ParsedResponse parsedResponse =
          interceptResponse<ProjectTaskSkill>(response, true);

      if (parsedResponse.isOk()) {
        for (ProjectTaskSkill projectTaskSkill in parsedResponse.body) {
          await database.updateSkill(projectTaskSkill.skill);
          await database.updateProjectTaskSkill(projectTaskSkill);
        }
      }
    } catch (ex) {
      print("sumthing");
    }
  }

  Future syncSkillsProjectTasksById(int projectId) async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/projectTask/$projectId",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, true);

    if (parsedResponse.isOk()) {
      for (Skill skill in parsedResponse.body) {
        await database.updateSkill(skill);
      }
    }
  }

  Future syncProjectTaskSkillsProjectTasksById(int projectTaskId) async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/projectTaskSkill/$projectTaskId",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectTaskSkill>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectTaskSkill projectTaskSkill in parsedResponse.body) {
        await database.updateProjectTaskSkill(projectTaskSkill);
      }
    }
  }

  Future syncSkillsRoutineTasksById(int routineId) async {
    http.Response response = await http.get(
        super.weburl + "api/Skills/routineTask/$routineId",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Skill>(response, true);

    if (parsedResponse.isOk()) {
      for (Skill skill in parsedResponse.body) {
        await database.updateSkill(skill);
      }
    }
  }
}
