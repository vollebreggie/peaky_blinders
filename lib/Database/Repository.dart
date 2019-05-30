import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Database/LocalDatabase.dart';
import 'package:peaky_blinders/Models/LoginCredentials.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:peaky_blinders/Models/UserProject.dart';

/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);
  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

final int NO_INTERNET = 404;

class RepositoryOld {
  static final RepositoryOld _repo = new RepositoryOld._internal();
  static final String webUrl = "http://192.168.178.11:45455/";
  LocalDatabase database;
  int loggedInUserId = 0;
  get weburl => webUrl;

  static RepositoryOld get() {
    return _repo;
  }

  RepositoryOld._internal() {
    //database = LocalDatabase.get();
  }

  Future<List<Project>> getProjectList() async {

    http.Response response = await http
        .get(webUrl + "api/Projects/list/" + loggedInUserId.toString())
        .catchError((resp) {
      print(resp.toString());
    });

    List<Project> projectList = [];
    List<dynamic> list = json.decode(response.body);
    for (dynamic jsonProject in list) {
      Project project = new Project(
          title: jsonProject["title"],
          id: jsonProject["id"],
          description: jsonProject["description"],
          priority: jsonProject["priority"],
          imagePathServer: jsonProject["imagePath"],
          imagePathLocal: "",
          totalPoints: jsonProject["totalPoints"],
          completedPoints: jsonProject["completedPoints"],
          started: DateTime.tryParse(jsonProject["started"].toString()),
          completed: DateTime.tryParse(jsonProject["completed"].toString()),
          lastUpdated:
              DateTime.tryParse(jsonProject["lastUpdated"].toString()));

          projectList.add(project);
    }
    return projectList;
  }

  Future<List<ProjectTask>> getProjectTasksList() async {

    http.Response response = await http
        .get(webUrl + "api/ProjectTasks/list/" + loggedInUserId.toString())
        .catchError((resp) {
      print(resp.toString());
    });

    List<ProjectTask> projectTaskList = [];
    List<dynamic> list = json.decode(response.body);
    for (dynamic jsonTask in list) {
        Map<String, dynamic> jsonProject = jsonTask["project"];
        Project project = new Project(
          title: jsonProject["title"],
          id: jsonProject["id"],
          description: jsonProject["description"],
          priority: jsonProject["priority"],
          imagePathServer: jsonProject["imagePath"],
          imagePathLocal: "",
          totalPoints: jsonProject["totalPoints"],
          completedPoints: jsonProject["completedPoints"],
          started: DateTime.tryParse(jsonProject["started"].toString()),
          completed: DateTime.tryParse(jsonProject["completed"].toString()),
          lastUpdated:
              DateTime.tryParse(jsonProject["lastUpdated"].toString()));

        ProjectTask task = new ProjectTask(
            id: jsonTask["id"],
            title: jsonTask["title"],
            description: jsonTask["description"],
            priority: jsonTask["priority"],
            points: jsonTask["points"],
            project: project,
            completed: DateTime.tryParse(jsonTask["completed"].toString()));

        projectTaskList.add(task);
      }
      return projectTaskList;
  }

  Future<List<Project>> getProject() async {
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    http.Response response = await http
        .get(webUrl + "api/Projects/user/" + loggedInUserId.toString())
        .catchError((resp) {
      print(resp.toString());
    });

    //  if(response == null) {
    //    return new ParsedResponse(NO_INTERNET, []);
    //  }

    //  //If there was an error return an empty list
    //  if(response.statusCode < 200 || response.statusCode >= 300) {
    //    return new ParsedResponse(response.statusCode, []);
    //  }
    // Decode and go to the items part where the necessary book information is
    List<dynamic> list = json.decode(response.body);
    List<dynamic> tasksList = [];
    for (dynamic jsonProject in list) {
      database.deleteUsersFromProject(jsonProject["id"]);
      List<User> userInProject = [];
      for (dynamic jsonUserProject in jsonProject["userProjects"]) {
        dynamic jsonUser = jsonUserProject["user"];
        User user = new User(
            id: jsonUser["id"],
            firstName: jsonUser["firstname"],
            identiyId: jsonUser["identityId"],
            image: jsonUser["image"]);

        UserProject userProject = new UserProject(
            projectId: jsonUserProject["projectId"],
            userId: jsonUserProject["userId"]);
        database.updateUserProject(userProject);

        database.updateUser(user);
        userInProject.add(user);
      }

      for (dynamic jsonTask in jsonProject["tasks"]) {
        dynamic jsonUser = jsonTask["user"];
        User user = new User(
            id: jsonUser["id"],
            firstName: jsonUser["firstname"],
            identiyId: jsonUser["identityId"],
            image: jsonUser["image"]);

        database.updateUser(user);

        ProjectTask task = new ProjectTask(
            id: jsonTask["id"],
            title: jsonTask["title"],
            description: jsonTask["description"],
            priority: jsonTask["priority"],
            points: jsonTask["points"],
            projectId: jsonProject["id"],
            userId: user.id,
            completed: DateTime.tryParse(jsonTask["completed"].toString()));

        tasksList.add(task);
      }

     
      Project project = new Project(
          title: jsonProject["title"],
          id: jsonProject["id"],
          description: jsonProject["description"],
          priority: jsonProject["priority"],
          imagePathServer: jsonProject["imagePath"],
          imagePathLocal: "",
          totalPoints: jsonProject["totalPoints"],
          completedPoints: jsonProject["completedPoints"],
          started: DateTime.tryParse(jsonProject["started"].toString()),
          completed: DateTime.tryParse(jsonProject["completed"].toString()),
          lastUpdated:
              DateTime.tryParse(jsonProject["lastUpdated"].toString()));

      // networkProjects.add(project);
      database.updateProject(project);
      for (ProjectTask task in tasksList) {
        //database.getProjectTasks();
        //if(database.getProjectTaskById(task.id) == null) {
        database.updateProjectTask(task);
        //}

      }
    }

    return database.getProjects();

//     List<ProjectTask> databaseProjectTask = await database.getProjectTasks([]..addAll(networkProjectTasks.keys));
//     for(ProjectTask book in databaseProjectTask) {
//       networkProjectTasks[book.id] = book;
//     }
// //new ParsedResponse(response.statusCode, []..addAll(networkProjectTasks.values));
//     return database.getProjectTasks();
    //return databaseProjectTask;
  }

  Future setUsersToProject(List<User> users, int projectId) async {
    List<Map<String, dynamic>> mappedUsers = [];
    for (User user in users) {
      mappedUsers.add(user.toMap());
    }

    String jsonMap = jsonEncode(mappedUsers);
    http.Response response = await http.post(
        webUrl + "api/Projects/users/${projectId}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
    //database.updateProjectTask(projectTask);
    getProject();
  }

  Future createProjectTask(ProjectTask projectTask) async {
    int id = projectTask.project.id;
    projectTask.project = null;
    projectTask.id = 0;
    projectTask.completed = null;
    String jsonMap = jsonEncode(projectTask.toMap());
    http.Response response = await http.post(webUrl + "api/ProjectTasks/${id}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });
    //database.updateProjectTask(projectTask);
    getProject();
  }

  Future login(username, password) async {
    String jsonMap = jsonEncode(
        new LoginCredentials(username: username, password: password).toMap());
    http.Response response = await http.post(webUrl + "api/auth/login",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    Map<String, dynamic> tokenData = json.decode(response.body);
    Token token = new Token(
        auth_token: tokenData["auth_token"],
        expires_in: tokenData["expires_in"]);
    Map<String, dynamic> userData = await getUser(tokenData["id"]);
    User user = new User(
        id: userData["id"],
        firstName: userData["firstname"],
        identiyId: tokenData["identityId"],
        token: token,
        image: userData["image"]);
    loggedInUserId = user.id;
    database.updateToken(token);
    database.updateUser(user);
  }

  Future<User> getUserLocal() async {
    return await database.getUser();
  }

  Future<Map<String, dynamic>> getUser(id) async {
    String jsonMap = jsonEncode(id);
    http.Response response = await http.post(webUrl + "api/accounts/user",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    return json.decode(response.body);
  }

  Future<List<User>> getUsers() async {
    http.Response response = await http.get(webUrl + "api/accounts/users",
        headers: {"Content-Type": "application/json"}).catchError((resp) {
      print(resp.toString());
    });

    List<dynamic> list = json.decode(response.body);
    List<User> users = new List<User>();
    for (dynamic jsonUser in list) {
      User user = new User(
          id: jsonUser["id"],
          firstName: jsonUser["firstname"],
          image: jsonUser["image"]);
      users.add(user);
      database.updateUser(user);
    }
    return users;
  }

  Future updateProjectTask(ProjectTask projectTask) async {
    http.Response response = await http
        .get(webUrl +
            "api/ProjectTasks/${projectTask.id}/${projectTask.project.id}")
        .catchError((resp) {});

    projectTask.project = null;
    String jsonMap = jsonEncode(projectTask.toMap());
    http.Response response2 = await http.put(
        webUrl + "ProjectTasks/${projectTask.id}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
    //database.updateProjectTask(projectTask);
    getProject();
  }

  upload(File imageFile, int projectId) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(webUrl + "api/Projects/image/${projectId}");

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

  Future completeTask(int taskId) async {
    var response = await http
        .get(webUrl + "api/ProjectTasks/completed/${taskId}")
        .catchError((resp) {});
    getProject();
  }

  Future<List<ProjectTask>> getProjectTasks() async {
    return database.getProjectTasks();
  }

  Future<List<ProjectTask>> getProjectTasksWithCompleted() async {
    return database.getProjectTasksWithCompleted();
  }

  Future<List<User>> getUserByProjectId(int projectId) async {
    return database.getUsersByProjectId(projectId);
  }

  Future<String> getProjectImage(int projectId) async {
    return database.getProjectImagepath(projectId);
  }

  Future<List<ProjectTask>> getProjectTasksByProjectId(int projectId) async {
    return database.getProjectTasksByProjectId(projectId);
  }

  Future<List<User>> getAllUserByProjectId(int projectId) async {
    List<User> allUsers = await database.getUsers();
    List<User> users = await database.getUsersByProjectId(projectId);
    for (int i = 0; i < allUsers.length; i++) {
      if (users.where((u) => u.id == allUsers[i].id).length != 0) {
        allUsers[i].selected = true;
      } else {
        allUsers[i].selected = false;
      }
    }
    return allUsers;
  }

  Future<List<Project>> getProjects() async {
    return database.getProjects();
  }

  Future<Token> getToken() async {
    return database.getToken();
  }

  Future updateProjectImage(File image, int projectId) async {
    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("image", new UploadFileInfo(image, basename(image.path)));
    dio
        .post(webUrl + "api/Projects/image/${projectId}",
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ))
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  Future updateProject(Project project) async {
    Map<String, dynamic> map = project.toMap();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.put(
        webUrl + "api/Projects/${project.id}",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
    //database.updateProjectTask(projectTask);
    getProject();
  }

  Future postProject(Project project, File image, User user) async {
    Map<String, dynamic> map = project.toMap();
    String jsonMap = jsonEncode(map);
    http.Response response = await http.post(webUrl + "api/Projects",
        body: jsonMap,
        headers: {"Content-Type": "application/json"}).catchError((resp) {});

    Map<String, dynamic> mapProject = json.decode(response.body);

    if (image != null) {
      await updateProjectImage(image, mapProject["id"]);
    }

    await postUserToProject(user.id, mapProject["id"]);

    await getProject();
  }

  Future postUserToProject(int userId, int projectId) async {
    http.Response response = await http.get(
        webUrl + "api/Projects/${userId}/${projectId}",
        headers: {"Content-Type": "application/json"}).catchError((resp) {});
  }

  Future close() async {
    return database.close();
  }

  // Future<List<ProjectTask>> getFavoriteProjectTasks() {
  //   return database.getFavoriteProjectTasks();
  // }

}
