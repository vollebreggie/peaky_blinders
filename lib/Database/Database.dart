import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProjectTaskDatabase {
  static final ProjectTaskDatabase _projectTaskDatabase =
      new ProjectTaskDatabase._internal();

  final String tableName = "ProjectTasks";

  Database db;

  bool didInit = false;

  static ProjectTaskDatabase get() {
    return _projectTaskDatabase;
  }

  ProjectTaskDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      //   await db.execute("CREATE TABLE $tableName ("
      //       "${ProjectTask.db_id} INTEGER PRIMARY KEY,"
      //       "${ProjectTask.db_title} TEXT,"
      //       "${ProjectTask.db_description} TEXT,"
      //       "${ProjectTask.db_started} DATETIME,"
      //       "${ProjectTask.db_completed} DATETIME"
      //       ")");

      await db.execute(
          'CREATE TABLE ProjectTask (id INTEGER PRIMARY KEY, title TEXT, description TEXT, started DATETIME, completed DATETIME)');

      await db.execute(
          'CREATE TABLE Project (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    });

    didInit = true;
  }

//##################PROJECT############################

  /// Get a project by its id, if there is not entry for that ID, returns null.
  Future<ProjectTask> getProject(String id) async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM Project WHERE id = "$id"');
    if (result.length == 0) return null;
    return new ProjectTask.fromMap(result[0]);
  }

  /// Get all projects with ids, will return a list with all the projects found
  Future<List<Project>> getProjects() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM PROJECT');
    List<Project> projects = [];

    for (Map<String, dynamic> item in result) {
      projects.add(new Project.fromMap(item));
    }
    return projects;
  }

  /// Inserts or replaces the project.
  Future updateProject(Project project) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Project (title, description) VALUES("${project.title}", "${project.description}")');
    });
  }

//############PROJECT TASKS #######################
  /// Get a projectTask by its id, if there is not entry for that ID, returns null.
  Future<ProjectTask> getProjectTask(String id) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ProjectTask WHERE ${ProjectTask.db_id} = "$id"');
    if (result.length == 0) return null;
    return new ProjectTask.fromMap(result[0]);
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasksByIds(List<String> ids) async {
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery(
        'SELECT * FROM ProjectTask WHERE ${ProjectTask.db_id} IN ($idsString)');
    var projectTasks = [];
    for (Map<String, dynamic> item in result) {
      projectTasks.add(new ProjectTask.fromMap(item));
    }
    return projectTasks;
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasks() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM ProjectTask');
    List<ProjectTask> projectTasks = [];

    for (Map<String, dynamic> item in result) {
      projectTasks.add(new ProjectTask.fromMap(item));
    }
    return projectTasks;
  }

  // Future<List<ProjectTask>> getFavoriteProjectTasks() async{
  //   var db = await _getDb();
  //   var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${ProjectTask.db_star} = "1"');
  //   if(result.length == 0)return [];
  //   var projectTasks = [];
  //   for(Map<String,dynamic> map in result) {
  //     projectTasks.add(new ProjectTask.fromMap(map));
  //   }
  //   return projectTasks;
  // }

  /// Inserts or replaces the projectTask.
  Future updateProjectTask(ProjectTask projectTask) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO ProjectTask (${ProjectTask.db_title}, ${ProjectTask.db_description}, ${ProjectTask.db_started}, ${ProjectTask.db_completed}) VALUES("${projectTask.title}", "${projectTask.description}", "${projectTask.started}", "${projectTask.completed}")');
    });
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
