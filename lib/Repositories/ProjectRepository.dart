import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Models/UserProject.dart';
import 'package:peaky_blinders/Models/WebSocketMessage.dart';
import 'package:peaky_blinders/Repositories/BaseRepository.dart';
import 'package:http/http.dart' as http;
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';
import 'package:peaky_blinders/Repositories/ParsedResponse.dart';

class ProjectRepository extends BaseRepository {
  static final ProjectRepository _repo = new ProjectRepository._internal();
  LocalDatabase database;

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
    http.Response response = await http.post(super.weburl + "api/Projects/tv",
        body: jsonMessage,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
    print(response);
  }

  Future syncEverything() async {
    http.Response response =
        await http.get(super.weburl + "api/Projects/user/1");
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
    http.Response response =
        await http.get(super.weburl + "api/Projects/user/1");
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
    http.Response response =
        await http.get(super.weburl + "api/deviceConnections");
    ParsedResponse parsedResponse = interceptResponse<Device>(response, true);

    if (parsedResponse.isOk()) {
      return parsedResponse.body;
    }
  }

  Future syncProject(projectId) async {
    //User user = await database.getLoggedInToken();
    http.Response response =
        await http.get(super.weburl + "api/Projects/$projectId");
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

  upload(File imageFile, int projectId) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(super.weburl + "api/Projects/image/${projectId}");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<int> getProjectCount() async {
    return await database.getAmountOfProjects();
  }

  Future postProject(Project project, File image, User user) async {
    project.users = [];
    project.users.add(user);
    project.milestones = orderMilestones(project.milestones);
    Map<String, dynamic> map = project.toMapWithoutId();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.post(super.weburl + "api/Projects",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      Project project = parsedResponse.body;
      postCompleteProject(project);
      if (image != null) {
        await updateProjectImage(image, project.id);
      }
    }

    await syncProjects();
    //  await postUserToProject(user.id, mapProject["id"]);
  }

  List<MileStone> orderMilestones(List<MileStone> milestones) {
    for (var i = 0; i < milestones.length; i++) {
      milestones[i].place = i;
      milestones[i].tasks = orderProjectTasks(milestones[i].tasks);
    }
    return milestones;
  }

  List<ProjectTask> orderProjectTasks(List<ProjectTask> tasks) {
    for (var i = 0; i < tasks.length; i++) {
      tasks[i].place = i;
      if(tasks[i].id == null){ tasks[i].id = 0; }
    }
    return tasks;
  }

  Future postProjectFromTv(Project project) async {
    project.milestones = orderMilestones(project.milestones);
    Map<String, dynamic> map = project.toMapWithoutId();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.post(super.weburl + "api/Projects",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    print(response.body);
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
    http.Response response = await http.get(
        super.weburl + "api/Projects/${userId}/${projectId}",
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
  }

  Future<List<User>> getUsersByProjectId(projectId) async {
    return database.getUsersByProjectId(projectId);
  }

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

  Future setUsersToProject(List<User> users, int projectId) async {
    List<Map<String, dynamic>> mappedUsers = [];
    for (User user in users) {
      mappedUsers.add(user.toMap());
    }

    String jsonMap = jsonEncode(mappedUsers);
    http.Response response = await http.post(
        super.weburl + "api/Projects/users/${projectId}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      for (UserProject userProject in parsedResponse.body.userProject) {
        database.updateUser(userProject.user);
        database.updateUserProject(userProject);
      }
    }
  }

  Future<List<User>> getUsers() async {
    return await database.getUsers();
  }

  Future postCompleteProject(Project project) async {
    database.updateProject(project);
    for (MileStone milestone in project.milestones) {
      database.updateMilestone(milestone);
      for (ProjectTask task in milestone.tasks) {
        database.updateProjectTask(task);
      }
    }
  }

  Future updateProject(Project project) async {
    project.milestones = orderMilestones(project.milestones);
    Map<String, dynamic> map = project.toMap();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.put(
        super.weburl + "api/Projects/${project.id}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    ParsedResponse parsedResponse = interceptResponse<Project>(response, false);

    if (parsedResponse.isOk()) {
      postCompleteProject(parsedResponse.body);
    }
  }
}
