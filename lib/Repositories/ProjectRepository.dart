import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Models/UserProject.dart';
import 'package:peaky_blinders/Models/WebSocketMessage.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';
import 'package:peaky_blinders/Repositories/ProblemRepository.dart';
import 'package:peaky_blinders/Repositories/SkillRepository.dart';

class ProjectRepository extends BaseRepository {
  static final ProjectRepository _repo = new ProjectRepository._internal();

  static ProjectRepository get() {
    return _repo;
  }

  ProjectRepository._internal() {
    database = LocalDatabase.get();
  }

  
  Future updateProjectName(name, socketId) async {
    var message = new WebSocketMessage(
        header: "project", socketId: socketId, device: "Phone", body: name);
    String jsonMessage = jsonEncode(message.toMap());
    http.Response response = await http
        .post(super.weburl + "api/Projects/tv", body: jsonMessage, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {
      print(resp.toString());
    });
    print(response);
  }

  Future syncEverything() async {
    http.Response response = await http.get(super.weburl + "api/Projects/user/",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Project>(response, true);

    if (parsedResponse.isOk()) {
      for (Project project in parsedResponse.body) {
        database.updateProject(project);
        MileStoneRepository.get().syncMilestonesByProjectId(project.id);
        for (UserProject userProject in project.userProject) {
          database.updateUser(userProject.user);
          database.updateUserProject(userProject);
        }
      }
    }
  }

  Future syncProjects() async {
    //User user = await database.getLoggedInToken();
    http.Response response = await http.get(super.weburl + "api/Projects/user/",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Project>(response, true);

    if (parsedResponse.isOk()) {
      for (Project project in parsedResponse.body) {
        database.updateProject(project);
        for (UserProject userProject in project.userProject) {
          database.updateUser(userProject.user);
          database.updateUserProject(userProject);
        }
      }
    }
  }

  Future<Project> getFirstProject() async {
    return await database.getFirstProject();
  }

  Future<List<ProjectDropdown>> getProjectDropdown() async {
    return await database.getProjectDropdown();
  }

  Future<List<Device>> getDevices() async {
    //User user = await database.getLoggedInToken();
    http.Response response = await http.get(
        super.weburl + "api/deviceConnections",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Device>(response, true);

    if (parsedResponse.isOk()) {
      return parsedResponse.body;
    }
  }

  Future syncProject(projectId) async {
    //User user = await database.getLoggedInToken();
    http.Response response = await http.get(
        super.weburl + "api/Projects/$projectId",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      Project project = parsedResponse.body;
      database.updateProject(project);
      for (UserProject userProject in project.userProject) {
        database.updateUser(userProject.user);
        database.updateUserProject(userProject);
      }
    }
  }

  Future<List<Project>> getProjects() async {
    return await database.getProjects();
  }

  Future upload(File imageFile, Project project) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/Projects/image/${project.id}");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();

    // listen for response

    Project tempProject = Project.fromMap(
        json.decode(await response.stream.transform(utf8.decoder).first));
    project.imagePathServer = tempProject.imagePathServer;
    await updateProjectImageLocal(project);
  }

  Future<String> getProjectImage(int projectId) async {
    return database.getProjectImagepath(projectId);
  }

  Future uploadImage(File imageFile, Project project) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/Projects/image/${project.id}");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();

    // listen for response

    await database.updateProject(Project.fromMap(
        json.decode(await response.stream.transform(utf8.decoder).first)));
  }

  Future<int> getProjectCount() async {
    return await database.getAmountOfProjects();
  }

  Future postProject(Project project, File image, User user) async {
    project.users = [];
    project.users.add(user);
    if (project.milestones.length != 0) {
      project.milestones = orderMilestones(project.milestones);
    }

    Map<String, dynamic> map = project.toMapWithoutId();
    String jsonMap = jsonEncode(map);
    http.Response response =
        await http.post(super.weburl + "api/Projects", body: jsonMap, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      Project project = parsedResponse.body;
      await postCompleteProject(project);
      if (image != null) {
        await uploadImage(image, project);
      }
      await syncProjectUsers(project.id);
      await ProblemRepository.get().syncProblemsForProject(project.id);
      await SkillRepository.get().syncSkillsForTask(project.id);
      await syncProjectUsers(project.id);
    }
  }

  Future syncProjectUsers(int projectId) async {
    http.Response response = await http
        .get(super.weburl + "api/Projects/user/$projectId", headers: {
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {});

    ParsedResponse parsedResponse =
        interceptResponse<UserProject>(response, true);

    if (parsedResponse.isOk()) {
      for (UserProject userProject in parsedResponse.body) {
        await database.updateUserProject(userProject);
      }
    }
  }

  List<MileStone> orderMilestones(List<MileStone> milestones) {
    int counter = 0;
    for (var i = 0; i < milestones.length; i++) {
      milestones[i].place = i;
      milestones[i].tasks = orderProjectTasks(milestones[i].tasks, counter);
      counter += milestones[i].tasks.length;
    }
    return milestones;
  }

  List<ProjectTask> orderProjectTasks(
      List<ProjectTask> tasks, int milestoneCounter) {
    for (var i = 0; i < tasks.length; i++) {
      tasks[i].place = i + milestoneCounter;
      if (tasks[i].id == null) {
        tasks[i].id = 0;
      }
    }
    return tasks;
  }

  Future postProjectFromTv(Project project) async {
    project.milestones = orderMilestones(project.milestones);
    Map<String, dynamic> map = project.toMapWithoutId();
    String jsonMap = jsonEncode(map);
    http.Response response =
        await http.post(super.weburl + "api/Projects", body: jsonMap, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      await postCompleteProject(parsedResponse.body);
    }
  }

  Future updateProjectImage(File image, int projectId) async {
    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("image", new UploadFileInfo(image, basename(image.path)));
    dio
        .post(super.weburl + "api/Projects/image/${projectId}",
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ))
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  Future postUserToProject(int userId, int projectId) async {
    http.Response response = await http
        .get(super.weburl + "api/Projects/${userId}/${projectId}", headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    }).catchError((resp) {});
  }

  Future<List<User>> getUsersByProjectId(projectId) async {
    return database.getUsersByProjectId(projectId);
  }

  // Future<List<Problem>> getProblemsByProjectId(projectId) async {
  //   return database.getProblemsByProjectId(projectId);
  // }

  Future<Project> getProject(id) async {
    return await database.getProject(id);
  }

  Future<Project> getProjectWithMilestones(projectId) async {
    return await database.getProjectWithMilestones(projectId);
  }

  Future<List<User>> getAllUnselectedUsersByProjectId(int projectId) async {
    List<User> unselectedUsers = [];
    List<User> allUsers = await database.getUsers();
    List<User> users = await database.getUsersByProjectId(projectId);
    for (int i = 0; i < allUsers.length; i++) {
      if (users.where((u) => u.id == allUsers[i].id).length == 0) {
        User user = allUsers[i];
        user.selected = false;
        unselectedUsers.add(user);
      }
    }

    return unselectedUsers;
  }

  // Future<List<Problem>> getAllUnselectedProblemsByProjectId(
  //     int projectId) async {
  //   List<Problem> unselectedProblems = [];
  //   List<Problem> allProblems = await database.getProblems();
  //   List<Problem> problems = await database.getProblemsByProjectId(projectId);
  //   for (int i = 0; i < allProblems.length; i++) {
  //     if (problems.where((u) => u.id == allProblems[i].id).length == 0) {
  //       Problem problem = allProblems[i];
  //       problem.selected = false;
  //       unselectedProblems.add(problem);
  //     }
  //   }

  //   return unselectedProblems;
  // }

  Future setUsersToProject(List<User> users, int projectId) async {
    List<Map<String, dynamic>> mappedUsers = [];
    for (User user in users) {
      mappedUsers.add(user.toMap());
    }

    String jsonMap = jsonEncode(mappedUsers);
    http.Response response = await http.post(
        super.weburl + "api/Projects/users/${projectId}",
        body: jsonMap,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {});
    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      for (UserProject userProject in parsedResponse.body.userProject) {
        database.updateUser(userProject.user);
        database.updateUserProject(userProject);
      }
    }
  }

  Future setProblemsToProject(List<Problem> problems, int projectId) async {
    List<Map<String, dynamic>> mappedProblems = [];
    for (Problem problem in problems) {
      mappedProblems.add(problem.toMap());
    }

    String jsonMap = jsonEncode(mappedProblems);
    http.Response response = await http.post(
        super.weburl + "api/Projects/probems/${projectId}",
        body: jsonMap,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectProblem>(response, false);

    if (parsedResponse.isOk()) {
      for (ProjectProblem projectProblem
          in parsedResponse.body.projectProblems) {
        //database.updateProblem(projectProblem.problem);
        database.updateProjectProblem(projectProblem);
      }
    }
  }

  Future setProjectProblem(ProjectProblem projectProblem) async {
    http.Response response = await http.get(
        super.weburl +
            "api/Projects/problem/${projectProblem.projectId}/${projectProblem.problemId}",
        headers: {HttpHeaders.authorizationHeader: await getAuthHeader()});
    ParsedResponse parsedResponse =
        interceptResponse<ProjectProblem>(response, false);

    if (parsedResponse.isOk()) {
      if ((parsedResponse.body as ProjectProblem).problemId == 0) {
        await database.deleteProjectProblemById(
            (parsedResponse.body as ProjectProblem).id);
      } else {
        await database.updateProjectProblem(parsedResponse.body);
      }
    }
  }

  Future<List<User>> getUsers() async {
    return await database.getUsers();
  }

  Future postCompleteProject(Project project) async {
    database.updateProject(project);
    if (project.milestones != null) {
      for (MileStone milestone in project.milestones) {
        database.updateMilestone(milestone);
        if (milestone.tasks != null) {
          for (ProjectTask task in milestone.tasks) {
            database.updateProjectTask(task);
          }
        }
      }
    }
  }

  Future updateProjectImageLocal(Project project) async {
    await database.updateProject(project);
  }

  Future updateProject(Project project) async {
    project.milestones = orderMilestones(project.milestones);
    Map<String, dynamic> map = project.toMap();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.put(
        super.weburl + "api/Projects/${project.id}",
        body: jsonMap,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: await getAuthHeader()
        }).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      postCompleteProject(parsedResponse.body);
      SkillRepository.get()
          .syncSkillsForTask((parsedResponse.body as Project).id);
    }
  }

  /// Delete project from the server and local database
  /// Param: project id
  Future deleteProjectByIdAsync(int projectId) async {
    //TODO:: create delete function on server side
    http.Response response =
        await http.delete(super.weburl + "api/Projects/$projectId", headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    });

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    //TODO:: what to do when the response is not ok?
    if (parsedResponse.isOk()) {
      await database.deleteProjectByIdAsync(projectId);
    }
  }

  /// Delete users from the project from both the server and local database
  /// Param: project id
  Future deleteUsersFromProjectByProjectIdAsync(int projectId) async {
    http.Response response = await http
        .delete(super.weburl + "api/Projects/users/$projectId", headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await getAuthHeader()
    });

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    //TODO:: what to do when the response is not ok?
    if (parsedResponse.isOk()) {
      await database.deleteUsersFromProjectByProjectIdAsync(projectId);
    }
  }
}
