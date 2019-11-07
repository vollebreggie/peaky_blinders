import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Log.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/System.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class ProblemRepository extends BaseRepository {
  static final ProblemRepository _repo = new ProblemRepository._internal();
  LocalDatabase database;
  User user;
  static ProblemRepository get() {
    return _repo;
  }

  ProblemRepository._internal() {
    database = LocalDatabase.get();
  }

  Future<List<Problem>> getProblems() async {
    return await database.getProblems();
  }

  Future removeProblem(Problem problem) async {
    http.Response response = await http.delete(
        super.weburl + "api/Problems/${problem.id}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, false);

    if (parsedResponse.isOk()) {
      await database
          .deleteProblemByIdAsync((parsedResponse.body as Problem).id);
    }
  }

  Future<String> getImageProblem(Problem problem) async {
    return await database.getImageProblem(problem);
  }

  Future postProblem(File imageFile, Problem problem) async {
    http.Response response = await http.post(super.weburl + "api/Problems",
        body: jsonEncode(problem.toMap()),
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader(),
          "Content-Type": "application/json"});
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, false);

    if (parsedResponse.isOk()) {
      if (imageFile != null) {
        await postProblemWithImage(imageFile, parsedResponse.body);
      } else if (imageFile == null) {
        await database.updateProblem(parsedResponse.body);
      }
    }
  }

  Future postProblemWithImage(File imageFile, Problem problem) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/Problems/image/${problem.id}");

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
    await database.updateProblem(Problem.fromMap(
        json.decode(await response.stream.transform(utf8.decoder).first)));
  }

  Future syncProblemsForProject(int projectId) async {
    http.Response response = await http.get(
        super.weburl + "api/Problems/project/${projectId}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectProblem>(response, true);

    if (parsedResponse.isOk()) {
      for (ProjectProblem projectProblem in parsedResponse.body) {
        await database.updateProjectProblem(projectProblem);
      }
    }
  }

  Future<List<Problem>> getAllProblemsForProjectById(int projectId) async {
    return await database.getAllProblemsForProjectById(projectId);
  }

  Future<List<Problem>> getSelectedProblemsByProjectId(int projectId) async {
    return await database.getSelectedProblemsByProjectId(projectId);
  }

  Future createProblem(Problem problem) async {
    http.Response response = await http.post(super.weburl + "api/Problems",
        body: jsonEncode(problem.toMap()),
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateProblem(parsedResponse.body);
    }
  }

  Future changePriorityProblems(List<Problem> problems) async {
    http.Response response = await http.put(super.weburl + "api/Problems",
        body: jsonEncode(Master.problemsToMap(problems)),
        headers: {
          HttpHeaders.authorizationHeader: await getAuthHeader(),
          "Content-Type": "application/json"
        });
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, true);

    if (parsedResponse.isOk()) {
      for (Problem problem in parsedResponse.body) {
        await database.updateProblem(problem);
      }
    }
  }

  Future updateProblem(Problem problem) async {
    http.Response response = await http.put(
        super.weburl + "api/Problems/${problem.id}",
        body: jsonEncode(problem.toMap()),
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, false);

    if (parsedResponse.isOk()) {
      await database.updateProblem(parsedResponse.body);
    }
  }

  Future syncProblems() async {
    http.Response response = await http.get(super.weburl + "api/Problems",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Problem>(response, true);

    if (parsedResponse.isOk()) {
      for (Problem problem in parsedResponse.body) {
        await database.updateProblem(problem);
      }
    }
  }
}
