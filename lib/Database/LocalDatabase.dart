import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Models/UserProject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static final LocalDatabase _localDatabase = new LocalDatabase._internal();

  final String tableName = "ProjectTasks";

  Database db;

  bool didInit = false;

  static LocalDatabase get() {
    return _localDatabase;
  }

  LocalDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (didInit == false) await _init();
    return db;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo8.db");
    db = await openDatabase(path, version: 3,
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
          'CREATE TABLE ProjectTask (id INTEGER, title TEXT, description TEXT, started DATETIME, completed DATETIME, priority TEXT, points INTEGER, place INTEGER, milestoneId INTEGER, projectId INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(id), FOREIGN KEY(projectId) REFERENCES project(id), FOREIGN KEY(milestoneId) REFERENCES milestone(id))');

      await db.execute('CREATE UNIQUE INDEX taskId ON ProjectTask (id)');

      await db.execute(
          'CREATE TABLE RoutineTaskSetting (id INTEGER, title TEXT, description TEXT, points INTEGER, place INTEGER, monday INTEGER, tuesday INTEGER, wednesday INTEGER, thursday INTEGER, friday INTEGER, saturday INTEGER, sunday INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(id))');

      await db.execute(
          'CREATE UNIQUE INDEX routineSettingId ON RoutineTaskSetting (id)');

      await db.execute(
          'CREATE TABLE RoutineTask (id INTEGER, title TEXT, description TEXT, started DATETIME, completed DATETIME, point INTEGER, place INTEGER, points INTEGER, routineTaskSettingId INTEGER, FOREIGN KEY(routineTaskSettingId) REFERENCES routineTaskSetting(id))');

      await db.execute('CREATE UNIQUE INDEX routineId ON RoutineTask (id)');

      await db.execute(
          'CREATE TABLE Project (id INTEGER, title TEXT, description TEXT, priority TEXT, image_local Text, imagePath TEXT, totalPoints INTEGER, completedPoints INTEGER, completed DATETIME, started DATETIME, lastUpdated DATETIME)');

      await db.execute(
          'CREATE TABLE MileStone (id INTEGER, title TEXT, place INTEGER, image TEXT, startDate DATETIME, endDate DATETIME, completed DATETIME, projectId INTEGER, FOREIGN KEY(projectId) REFERENCES project(id))');

      await db.execute('CREATE UNIQUE INDEX milestoneId ON MileStone(id)');

      await db.execute('CREATE UNIQUE INDEX projectId ON Project(id)');

      await db.execute(
          'CREATE TABLE User (id INTEGER PRIMARY KEY, identityId TEXT, image TEXT, firstname TEXT, lastname TEXT, username TEXT, password Text)');

      await db.execute(
          'CREATE TABLE Token (id INTEGER PRIMARY KEY, auth_token TEXT, expires_in INTEGER)');

      await db.execute(
          'CREATE TABLE LoggedInUser (id INTEGER PRIMARY KEY, identityId TEXT, image TEXT, firstname TEXT, lastname TEXT, tokenId INTEGER, username TEXT, password Text)');

      await db.execute(
          'CREATE TABLE UserProject (id INTEGER PRIMARY KEY, userId INTEGER, projectId INTEGER, FOREIGN KEY(projectId) REFERENCES project(id), FOREIGN KEY(userId) REFERENCES user(id))');
    });

    didInit = true;
  }

//##################TOKEN###############################
  /// Get a token
  Future<Token> getToken() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM Token');
    if (result.length == 0) return null;
    return new Token.fromMap(result[0]);
  }

  /// Get a token
  Future<List<ProjectDropdown>> getProjectDropdown() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM Project');
    if (result.length == 0) return null;
    List<ProjectDropdown> projects = [];

    for (Map<String, dynamic> item in result) {
      projects.add(new ProjectDropdown.fromMap(item));
    }
    return projects;
  }

  /// Inserts or replaces the user.
  Future updateToken(Token token) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'REPLACE INTO Token (auth_token, expires_in) VALUES("${token.auth_token}", "${token.expires_in}")');
    });
  }

  /// Inserts or replaces the user.
  Future updateLoggedInUser(User user) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'REPLACE INTO LoggedInUser (id, identityId, firstName, image) VALUES("${user.id}", "${user.identiyId}", "${user.firstName}", "${user.image}")');
    });
  }

  Future<User> getLoggedInUser() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM LoggedInUser');
    if (result.length == 0) return null;
    return new User.fromMap(result[0]);
  }

  Future deleteUsersFromProject(projectId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn
          .rawInsert('DELETE FROM UserProject WHERE projectId = $projectId');
    });
  }

  /// Inserts or replaces the userProject.
  Future updateUserProject(UserProject userProject) async {
    var db = await _getDb();

    var firstResult = await db.rawQuery(
        'SELECT * FROM UserProject WHERE projectId = "${userProject.projectId}" AND userId = "${userProject.userId}"');

    if (firstResult.length == 0) {
      await db.transaction((txn) async {
        var result = await txn.rawInsert(
            'REPLACE INTO UserProject (userId, projectId) VALUES("${userProject.userId}", "${userProject.projectId}")');
      });
    }
  }

  /// Get a user
  Future<List<User>> getUsersByProjectId(int projectId) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM UserProject WHERE projectId = "$projectId"');
    List<User> users = [];

    for (Map<String, dynamic> item in result) {
      UserProject userProject = new UserProject.fromMap(item);

      var result = await db
          .rawQuery('SELECT * FROM User WHERE id = ${userProject.userId}');
      for (Map<String, dynamic> item in result) {
        User user = new User.fromMap(item);
        user.selected = true;
        users.add(user);
      }
    }
    return users;
  }

//################USER##################################
  /// Get a user
  Future<User> getUser() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM User');
    if (result.length == 0) return null;
    return new User.fromMap(result[0]);
  }

  Future<List<User>> getUsers() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM User');
    if (result.length == 0) return null;

    List<User> users = [];

    for (Map<String, dynamic> item in result) {
      User user = new User.fromMap(item);
      users.add(user);
    }
    return users;
  }

  /// Inserts or replaces the user.
  Future updateUser(User user) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'REPLACE INTO User (id, identityId, firstName, image) VALUES("${user.id}", "${user.identiyId}", "${user.firstName}", "${user.image}")');
    });
  }

//##################PROJECT############################

  /// Get a project by its id, if there is not entry for that ID, returns null.
  Future<Project> getProject(int id) async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM Project WHERE id = "$id"');
    if (result.length == 0) return null;
    Project project = new Project.fromMap(result[0]);
    project.users = await getUsersByProjectId(project.id);
    return project;
  }

  Future<Project> getProjectWithMilestones(int id) async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM Project WHERE id = "$id"');
    if (result.length == 0) return null;
    Project project = new Project.fromMap(result[0]);
    project.milestones = await getMilestonesByProjectId(id);

    project.users = await getUsersByProjectId(project.id);
    return project;
  }

  Future<Project> getFirstProject() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM PROJECT');

    if (result.isEmpty) {
      return null;
    }
    Project project = new Project.fromMap(result.first);
    List<MileStone> milestones = await getMilestonesByProjectId(project.id);
    if (milestones
        .where((m) =>
            m.startDate.isBefore(DateTime.now()) &&
            m.endDate.isAfter(DateTime.now()))
        .isNotEmpty) {
      project.milestones = [];

      MileStone milestone = (milestones
          .where((m) =>
              m.startDate.isBefore(DateTime.now()) &&
              m.endDate.isAfter(DateTime.now()))
          .first);

      milestone.tasks = await getProjectTasksByMilestoneId(milestone.id);
      project.milestones.add(milestone);
      return project;
    }
    return null;
  }

  /// Get all projects with ids, will return a list with all the projects found
  Future<List<Project>> getProjects() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM PROJECT ORDER BY id');

    List<Project> projects = [];

    for (Map<String, dynamic> item in result) {
      try {
        Project project = new Project.fromMap(item);
        //List<ProjectTask> taskList = [];

        // var result = await db.rawQuery(
        //     'SELECT * FROM PROJECTTASK WHERE projectId = ${project.id}');
        // for (Map<String, dynamic> item in result) {
        //   taskList.add(new ProjectTask.fromMap(item));
        // }
        //project.tasks = taskList;
        project.users = await getUsersByProjectId(project.id);
        projects.add(project);
      } catch (excep) {}
    }
    return projects;
  }

  /// Delete all projects
  Future deleteAllProjects() async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Project');
    });
  }

  /// Inserts or replaces the project.
  Future updateProject(Project project) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'REPLACE INTO Project (id, title, description, priority, image_local, imagePath, totalPoints, completedPoints, completed, started, lastUpdated) VALUES("${project.id}", "${project.title}", "${project.description}", "${project.priority}", "${project.imagePathLocal}", "${project.imagePathServer}", "${project.totalPoints}", "${project.completedPoints}", "${project.completed}", "${project.started}", "${project.lastUpdated}")');
    });
  }

//############ MILESTONES #########################
  /// Inserts or replaces the milestone.
  Future updateMilestone(MileStone milestone) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'REPLACE INTO Milestone (id, title, startDate, endDate, projectId, place) VALUES("${milestone.id}", "${milestone.title}", "${milestone.startDate}", "${milestone.endDate}", "${milestone.projectId}", "${milestone.place}")');
    });
  }

  /// Get all milestones with ids, will return a list with all the milestones found
  Future<List<MileStone>> getMilestonesByProjectId(int id) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "Select * FROM Milestone WHERE projectId = ${id} ORDER BY place");
    // Order by case when priority LIKE '%@%' then 1 else 2 end");
    List<MileStone> milestones = [];
    for (Map<String, dynamic> item in result) {
      MileStone milestone = new MileStone.fromMap(item);

      var result = await db.rawQuery(
          "Select * FROM ProjectTask WHERE milestoneId = ${milestone.id} ORDER BY place");
      List<ProjectTask> projectTasks = [];
      for (Map<String, dynamic> item in result) {
        ProjectTask task = new ProjectTask.fromMap(item);
        task.project = await getProject(id);
        projectTasks.add(task);
      }
      milestone.tasks = projectTasks;
      milestones.add(milestone);
    }

    return milestones;
  }

//############PROJECT TASKS #######################
  /// Get a projectTask by its id, if there is not entry for that ID, returns null.
  Future<ProjectTask> getProjectTask(String id) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM ProjectTask WHERE ${Task.db_id} = "$id"');
    if (result.length == 0) return null;
    return new ProjectTask.fromMap(result[0]);
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasksByProjectId(int id) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "Select * FROM ProjectTask WHERE projectId = $id ORDER BY Case when priority = 'Paramount' then 1 when priority = 'Necessary' then 2 when priority = 'Valuable' then 3 when priority = 'Trivial' then 4 end And completed");
    // Order by case when priority LIKE '%@%' then 1 else 2 end");
    List<ProjectTask> projectTasks = [];
    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(id);
      projectTasks.add(task);
    }

    return projectTasks;
  }

  Future<List<ProjectTask>> getProjectTasksByMilestoneId(
      int milestoneId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "Select * FROM ProjectTask WHERE milestoneId = $milestoneId ORDER BY place And completed");
    // Order by case when priority LIKE '%@%' then 1 else 2 end");
    List<ProjectTask> projectTasks = [];
    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      projectTasks.add(task);
    }

    return projectTasks;
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasksByIds(List<String> ids) async {
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery(
        'SELECT * FROM ProjectTask WHERE ${Task.db_id} IN ($idsString)');
    var projectTasks = [];
    for (Map<String, dynamic> item in result) {
      projectTasks.add(new ProjectTask.fromMap(item));
    }
    return projectTasks;
  }

  Future<List<Task>> getTasksForTommorow() async {
    List<Task> tasks = [];
    tasks.addAll(await getRoutineTasksForTomorrow());
    tasks.addAll(await getProjectTaskForTomorrow());
    tasks.sort((a, b) => a.place.compareTo(b.place)); 
    return tasks;
  }

  Future<List<RoutineTask>> getRoutineTasksForTomorrow() async {
    List<RoutineTask> tasks = [];
    var db = await _getDb();
    var routineResult = await db.rawQuery(
        "SELECT * FROM RoutineTask WHERE completed == 'null' AND CAST(strftime('%s', started) AS integer) > CAST(strftime('%s', datetime('now','localtime')) AS integer) ORDER BY place");
    if (routineResult.isEmpty) {
      return [];
    }
    for (Map<String, dynamic> item in routineResult) {
      tasks.add(new RoutineTask.fromMap(item));
    }
    return tasks;
  }

  Future<List<ProjectTask>> getProjectTaskForTomorrow() async {
    List<ProjectTask> tasks = [];
    var projectResult = await db.rawQuery(
        "SELECT * FROM ProjectTask WHERE (completed == 'null' AND started == 'null') OR (completed == 'null' AND CAST(strftime('%s', started) AS integer) > CAST(strftime('%s', datetime('now','localtime')) AS integer)) ORDER BY place LIMIT 15");
    if (projectResult.isEmpty) {
      return [];
    }
    for (Map<String, dynamic> item in projectResult) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      tasks.add(task);
    }

    return tasks;
  }

  Future<List<ProjectTask>> getExistingTasksForToday() async {
    List<ProjectTask> tasks = [];
    var projectResult = await db.rawQuery(
        "SELECT * FROM ProjectTask WHERE completed == 'null' AND started == 'null' ORDER BY place LIMIT 15");
    for (Map<String, dynamic> item in projectResult) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      tasks.add(task);
    }

    return tasks;
  }

  Future<List<Task>> getTasksForToday() async {
    List<Task> tasks = [];
    tasks.addAll(await getProjectTasksForToday());
    tasks.addAll(await getRoutineTasksForToday());
    tasks.sort((a, b) => a.place.compareTo(b.place));
    return tasks;
  }

  Future<List<ProjectTask>> getProjectTasksForToday() async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ProjectTask WHERE completed == 'null' AND CAST(strftime('%s', started) AS integer) < CAST(strftime('%s', datetime('now','localtime')) AS integer) ORDER BY place");
    if (result.isEmpty) {
      return [];
    }
    List<ProjectTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      tasks.add(task);
    }
    return tasks;
  }

  Future<List<RoutineTask>> getRoutineTasksForToday() async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "SELECT * FROM RoutineTask WHERE completed == 'null' AND CAST(strftime('%s', started) AS integer) < CAST(strftime('%s', datetime('now','localtime')) AS integer) ORDER BY place");
    if (result.isEmpty) {
      return [];
    }
    List<RoutineTask> tasks = [];
    for (Map<String, dynamic> item in result) {
      RoutineTask task = new RoutineTask.fromMap(item);
      tasks.add(task);
    }
    return tasks;
  }

  Future<Task> getNextTasksForToday() async {
    List<Task> tasks = [];
    tasks.addAll(await getProjectTasksForToday());
    tasks.addAll(await getRoutineTasksForToday());
    if (tasks.length == 0) {
      return null;
    }
    tasks.sort((a, b) => a.place.compareTo(b.place));
    return tasks.first;
  }

  Future<int> getAmountOfProjects() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM Project");
    return result.length;
  }

  /// Delete all tasks
  Future deleteAllTasks() async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectTask');
    });
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasks() async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ProjectTask  WHERE completed = 'null' ORDER BY Case when priority = 'Paramount' then 1 when priority = 'Necessary' then 2 when priority = 'Valuable' then 3 when priority = 'Trivial' then 4 end");
    List<ProjectTask> projectTasks = [];

    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      task.user = await getUserById(task.userId);
      projectTasks.add(task);
    }
    return projectTasks;
  }

  /// Get all projectTasks with ids, will return a list with all the projectTasks found
  Future<List<ProjectTask>> getProjectTasksWithCompleted() async {
    var db = await _getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ProjectTask  WHERE completed != 'null' ORDER BY Case when priority = 'Paramount' then 1 when priority = 'Necessary' then 2 when priority = 'Valuable' then 3 when priority = 'Trivial' then 4 end");
    List<ProjectTask> projectTasks = [];

    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.project = await getProject(task.projectId);
      task.user = await getUserById(task.userId);
      projectTasks.add(task);
    }
    return projectTasks;
  }

  Future<User> getUserById(int id) async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM User WHERE id = "${id}"');
    if (result.isNotEmpty) return new User.fromMap(result.first);

    return null;
  }

  /// Get projectTask by id, will return specific task
  Future<ProjectTask> getProjectTaskById(int id) async {
    var db = await _getDb();
    var result =
        await db.rawQuery('SELECT * FROM ProjectTask WHERE id = "${id}"');
    if (result.isNotEmpty) return new ProjectTask.fromMap(result.single);

    return null;
  }

  Future<String> getProjectImagepath(int projectId) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT image_local FROM Project WHERE id = "${projectId}"');
    if (result.isNotEmpty) return result.single["image_local"];

    return "";
  }

  /// Inserts or replaces the projectTask.
  Future updateProjectTask(ProjectTask projectTask) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO ProjectTask (${Task.db_id}, ${Task.db_title}, ${Task.db_description}, ${Task.db_started}, ${Task.db_completed}, ${ProjectTask.db_projectId}, ${ProjectTask.db_priority}, ${Task.db_points}, ${ProjectTask.db_milestoneId}, ${Task.db_place}, ${ProjectTask.db_userId}) VALUES("${projectTask.id}", "${projectTask.title}", "${projectTask.description}", "${projectTask.started}", "${projectTask.completed}", "${projectTask.projectId}", "${projectTask.priority}", "${projectTask.points}", "${projectTask.milestoneId}", "${projectTask.place}", "${projectTask.userId}")');
    });
  }

  //########################ROUTINETAKS###########################################
  /// Inserts or replaces the RoutineTaskSetting.
  Future updateRoutineSetting(RoutineTaskSetting routineTaskSetting) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO RoutineTaskSetting (${RoutineTaskSetting.db_id}, ${RoutineTaskSetting.db_title}, ${RoutineTaskSetting.db_description}, ${RoutineTaskSetting.db_points}, ${RoutineTaskSetting.db_place}, ${RoutineTaskSetting.db_userId}, ${RoutineTaskSetting.db_monday}, ${RoutineTaskSetting.db_tuesday}, ${RoutineTaskSetting.db_wednesday}, ${RoutineTaskSetting.db_thursday}, ${RoutineTaskSetting.db_friday}, ${RoutineTaskSetting.db_saturday}, ${RoutineTaskSetting.db_sunday}) VALUES("${routineTaskSetting.id}", "${routineTaskSetting.title}", "${routineTaskSetting.description}", "${routineTaskSetting.points}", "${routineTaskSetting.place}", "${routineTaskSetting.userId}", "${routineTaskSetting.monday}", "${routineTaskSetting.tuesday}", "${routineTaskSetting.wednesday}", "${routineTaskSetting.thursday}", "${routineTaskSetting.friday}", "${routineTaskSetting.saturday}", "${routineTaskSetting.sunday}")');
    });
  }

  /// Inserts or replaces the RoutineTaskSetting.
  Future updateRoutineTask(RoutineTask routineTask) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO RoutineTask (${Task.db_id}, ${Task.db_title}, ${Task.db_description}, ${Task.db_points}, ${Task.db_place}, ${Task.db_started}, ${Task.db_completed}, ${RoutineTask.db_routineTaskSettingId}) VALUES("${routineTask.id}", "${routineTask.title}", "${routineTask.description}", "${routineTask.points}", "${routineTask.place}", "${routineTask.started}", "${routineTask.completed}", "${routineTask.routineTaskSettingId}")');
    });
  }

  Future<List<RoutineTask>> getRoutineTasks() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM RoutineTask");
    List<RoutineTask> routineTasks = [];

    for (Map<String, dynamic> item in result) {
      RoutineTask task = new RoutineTask.fromMap(item);
      routineTasks.add(task);
    }
    return routineTasks;
  }

  /// Get projectTask by id, will return specific task
  Future<RoutineTaskSetting> getRoutineSettingById(int id) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM RoutineTaskSetting WHERE id = "${id}"');
    if (result.isNotEmpty) return new RoutineTaskSetting.fromMap(result.single);

    return null;
  }

  /// Get all routineTasks
  Future<List<RoutineTaskSetting>> getRoutineSettings() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM RoutineTaskSetting");
    List<RoutineTaskSetting> routineTasks = [];

    for (Map<String, dynamic> item in result) {
      RoutineTaskSetting task = new RoutineTaskSetting.fromMap(item);
      routineTasks.add(task);
    }
    return routineTasks;
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
