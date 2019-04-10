import 'dart:async';
import 'package:peaky_blinders/Database/Database.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Models/User.dart';

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

class Repository {
  static final Repository _repo = new Repository._internal();

  ProjectTaskDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = ProjectTaskDatabase.get();
  }

  Future<List<Project>> getProject() async {
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    http.Response response = await http
        .get("http://192.168.178.11:45455/api/Projects")
        .catchError((resp) {});

    //  if(response == null) {
    //    return new ParsedResponse(NO_INTERNET, []);
    //  }

    //  //If there was an error return an empty list
    //  if(response.statusCode < 200 || response.statusCode >= 300) {
    //    return new ParsedResponse(response.statusCode, []);
    //  }
    // Decode and go to the items part where the necessary book information is
    List<dynamic> list = json.decode(response.body);

    Map<String, ProjectTask> networkProjects = {};

    for (dynamic jsonProject in list) {
      Project project = new Project(
          title: jsonProject["volumeInfo"]["title"], id: jsonProject["id"]);
    }

//     List<ProjectTask> databaseProjectTask = await database.getProjectTasks([]..addAll(networkProjectTasks.keys));
//     for(ProjectTask book in databaseProjectTask) {
//       networkProjectTasks[book.id] = book;
//     }
// //new ParsedResponse(response.statusCode, []..addAll(networkProjectTasks.values));
//     return database.getProjectTasks();
    //return databaseProjectTask;
  }

  Future updateProjectTask(ProjectTask projectTask) async {
    database.updateProjectTask(projectTask);
  }

  Future<List<ProjectTask>> getProjectTasks() async {
    return database.getProjectTasks();
  }

  Future<List<Project>> getProjects() async {
    return database.getProjects();
  }

  Future<Token> getToken() async {
    return database.getToken();
  }

  Future<User> getUser() async {
    return database.getUser();
  }

  Future updateProject(Project project) async {
    database.updateProject(project);
  }

  Future close() async {
    return database.close();
  }

  // Future<List<ProjectTask>> getFavoriteProjectTasks() {
  //   return database.getFavoriteProjectTasks();
  // }

}
