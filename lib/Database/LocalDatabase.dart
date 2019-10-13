import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/ProjectTaskSkill.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/RoutineTaskSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
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
    String path = join(documentsDirectory.path, "demo11.db");
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
          'CREATE TABLE Project (id INTEGER, title TEXT, place INTEGER, description TEXT, priority TEXT, image_local Text, imagePath TEXT, totalPoints INTEGER, completedPoints INTEGER, completed DATETIME, started DATETIME, lastUpdated DATETIME)');

      await db.execute(
          'CREATE TABLE MileStone (id INTEGER, title TEXT, place INTEGER, image TEXT, startDate DATETIME, endDate DATETIME, completed DATETIME, projectId INTEGER, FOREIGN KEY(projectId) REFERENCES project(id))');

      await db.execute('CREATE UNIQUE INDEX milestoneId ON MileStone(id)');

      await db.execute('CREATE UNIQUE INDEX projectId ON Project(id)');

      await db.execute(
          'CREATE TABLE User (id INTEGER PRIMARY KEY, identityId TEXT, amountOfSkills INTEGER, configured INTEGER, image TEXT, firstname TEXT, lastname TEXT, username TEXT, password Text)');

      await db.execute(
          'CREATE TABLE Master (id INTEGER PRIMARY KEY, name TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(id))');
      await db.execute('CREATE UNIQUE INDEX masterId ON Master(id)');

      await db.execute(
          'CREATE TABLE Reason (id INTEGER PRIMARY KEY, name TEXT, userId INTEGER, masterId INTEGER, FOREIGN KEY(userId) REFERENCES user(id), FOREIGN KEY(masterId) REFERENCES master(id))');
      await db.execute('CREATE UNIQUE INDEX reasonId ON Reason(id)');

      await db.execute(
          'CREATE TABLE Skill (id INTEGER PRIMARY KEY, place INTEGER, points INTEGER, title TEXT, description TEXT, imagePath TEXT, masterId INTEGER, userId INTEGER, problemId INTEGER, FOREIGN KEY(problemId) REFERENCES problem(id), FOREIGN KEY(userId) REFERENCES user(id), FOREIGN KEY(masterId) REFERENCES master(id))');
      await db.execute('CREATE UNIQUE INDEX skillId ON Skill(id)');

      await db.execute(
          'CREATE TABLE Problem (id INTEGER PRIMARY KEY, place INTEGER, name TEXT, description TEXT, imagePath TEXT, points INTEGER, userId INTEGER, masterId INTEGER, FOREIGN KEY(userId) REFERENCES user(id), FOREIGN KEY(masterId) REFERENCES master(id))');
      await db.execute('CREATE UNIQUE INDEX problemId ON Problem(id)');

      await db.execute(
          'CREATE TABLE Token (id INTEGER PRIMARY KEY, auth_token TEXT, expires_in INTEGER)');

      await db.execute(
          'CREATE TABLE LoggedInUser (id INTEGER PRIMARY KEY, identityId TEXT, image TEXT, firstname TEXT, lastname TEXT, tokenId INTEGER, configured INTEGER, username TEXT, password Text, amountOfSkills INTEGER)');

      await db.execute(
          'CREATE TABLE UserProject (id INTEGER PRIMARY KEY, userId INTEGER, projectId INTEGER, FOREIGN KEY(projectId) REFERENCES project(id), FOREIGN KEY(userId) REFERENCES user(id))');

      await db.execute(
          'CREATE TABLE ProjectProblem (id INTEGER PRIMARY KEY, projectId INTEGER, problemId INTEGER, FOREIGN KEY(projectId) REFERENCES project(id), FOREIGN KEY(problemId) REFERENCES problem(id))');
      await db.execute(
          'CREATE UNIQUE INDEX projectProblemId ON ProjectProblem(id)');

      await db.execute(
          'CREATE TABLE ProjectTaskSkill (id INTEGER PRIMARY KEY, projectTaskId INTEGER, skillId INTEGER, FOREIGN KEY(projectTaskId) REFERENCES projectTask(id), FOREIGN KEY(skillId) REFERENCES skill(id))');
      await db.execute(
          'CREATE UNIQUE INDEX projectTaskSkillId ON ProjectTaskSkill(id)');

      await db.execute(
          'CREATE TABLE RoutineTaskSkill (id INTEGER PRIMARY KEY, routineTaskId INTEGER, skillId INTEGER, FOREIGN KEY(routineTaskId) REFERENCES routineTask(id), FOREIGN KEY(skillId) REFERENCES skill(id))');
      await db.execute(
          'CREATE UNIQUE INDEX routineTaskSkillId ON RoutineTaskSkill(id)');

      await db.execute(
          'CREATE TABLE RoutineTaskSettingSkill (id INTEGER PRIMARY KEY, routineTaskSettingId INTEGER, skillId INTEGER, FOREIGN KEY(routineTaskSettingId) REFERENCES routineTaskSetting(id), FOREIGN KEY(skillId) REFERENCES skill(id))');
      await db.execute(
          'CREATE UNIQUE INDEX routineTaskSettingSkillId ON RoutineTaskSettingSkill(id)');
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
          'REPLACE INTO LoggedInUser (id, identityId, firstName, image, configured, amountOfSkills) VALUES("${user.id}", "${user.identiyId}", "${user.firstName}", "${user.image}", "${user.configured}", "${user.amountOfSkills}")');
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

  /// Inserts or replaces the userProject.
  Future updateProjectProblem(ProjectProblem projectProblem) async {
    var db = await _getDb();

    var firstResult = await db.rawQuery(
        'SELECT * FROM ProjectProblem WHERE projectId = "${projectProblem.projectId}" AND problemId = "${projectProblem.problemId}"');

    if (firstResult.length == 0) {
      await db.transaction((txn) async {
        var result = await txn.rawInsert(
            'REPLACE INTO ProjectProblem (id, problemId, projectId) VALUES("${projectProblem.id}", "${projectProblem.problemId}", "${projectProblem.projectId}")');
      });
    }
  }

  /// Inserts or replaces the userProject.
  Future updateProjectTaskSkill(ProjectTaskSkill projectTaskSkill) async {
    var db = await _getDb();

    var firstResult = await db.rawQuery(
        'SELECT * FROM ProjectTaskSkill WHERE projectTaskId = "${projectTaskSkill.projectTaskId}" AND skillId = "${projectTaskSkill.skillId}"');

    if (firstResult.length == 0) {
      await db.transaction((txn) async {
        var result = await txn.rawInsert(
            'REPLACE INTO ProjectTaskSkill (id, projectTaskId, skillId) VALUES("${projectTaskSkill.id}", "${projectTaskSkill.projectTaskId}", "${projectTaskSkill.skillId}")');
      });
    }
  }

  /// Inserts or replaces the userProject.
  Future updateRoutineTaskSettingSkill(
      RoutineTaskSettingSkill routineTaskSettingSkill) async {
    var db = await _getDb();

    var firstResult = await db.rawQuery(
        'SELECT * FROM RoutineTaskSettingSkill WHERE routineTaskSettingId = "${routineTaskSettingSkill.routineTaskSettingId}" AND skillId = "${routineTaskSettingSkill.skillId}"');

    if (firstResult.length == 0) {
      await db.transaction((txn) async {
        var result = await txn.rawInsert(
            'REPLACE INTO RoutineTaskSettingSkill (id, routineTaskSettingId, skillId) VALUES("${routineTaskSettingSkill.id}", "${routineTaskSettingSkill.routineTaskSettingId}", "${routineTaskSettingSkill.skillId}")');
      });
    }
  }

  /// Inserts or replaces the userProject.
  Future updateRoutineTaskSkill(RoutineTaskSkill routineTaskSkill) async {
    var db = await _getDb();

    var firstResult = await db.rawQuery(
        'SELECT * FROM RoutineTaskSkill WHERE routineTaskId = "${routineTaskSkill.routineTaskId}" AND skillId = "${routineTaskSkill.skillId}"');

    if (firstResult.length == 0) {
      await db.transaction((txn) async {
        var result = await txn.rawInsert(
            'REPLACE INTO RoutineTaskSkill (id, routineTaskId, skillId) VALUES("${routineTaskSkill.id}", "${routineTaskSkill.routineTaskId}", "${routineTaskSkill.skillId}")');
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

  Future<List<Problem>> getSelectedProblemsByProjectId(int projectId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ProjectProblem WHERE projectId = "$projectId"');
    List<Problem> problems = [];

    for (Map<String, dynamic> item in result) {
      ProjectProblem projectProblem = new ProjectProblem.fromMap(item);

      var result = await db.rawQuery(
          'SELECT * FROM Problem WHERE id = ${projectProblem.problemId} ORDER BY place');
      for (Map<String, dynamic> item in result) {
        Problem problem = new Problem.fromMap(item);
        problem.selected = true;
        problems.add(problem);
      }
    }
    return problems;
  }

  Future<List<Skill>> getSelectedSkillsByProjectTaskId(
      int projectTaskId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ProjectTaskSkill WHERE projectTaskId = "$projectTaskId"');
    List<Skill> skills = [];
    if (result.isEmpty) {
      return [];
    }
    for (Map<String, dynamic> item in result) {
      ProjectTaskSkill projectTaskSkill = new ProjectTaskSkill.fromMap(item);

      var result = await db.rawQuery(
          'SELECT * FROM Skill WHERE id = ${projectTaskSkill.skillId} ORDER BY place');
      for (Map<String, dynamic> item in result) {
        Skill skill = new Skill.fromMap(item);
        skill.selected = true;
        skills.add(skill);
      }
    }
    return skills;
  }

  Future<List<Skill>> getSelectedSkillsByRoutineTaskSettingId(
      int routineSettingId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM RoutineTaskSettingSkill WHERE routineTaskSettingId = "$routineSettingId"');
    List<Skill> skills = [];

    for (Map<String, dynamic> item in result) {
      ProjectTaskSkill projectTaskSkill = new ProjectTaskSkill.fromMap(item);

      var result = await db.rawQuery(
          'SELECT * FROM Skill WHERE id = ${projectTaskSkill.skillId} ORDER BY place');
      for (Map<String, dynamic> item in result) {
        Skill skill = new Skill.fromMap(item);
        skill.selected = true;
        skills.add(skill);
      }
    }
    return skills;
  }

  Future<List<Problem>> getAllProblemsForProjectById(int projectId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ProjectProblem WHERE projectId = "$projectId"');
    List<ProjectProblem> projectProblems = [];

    for (Map<String, dynamic> item in result) {
      ProjectProblem projectProblem = new ProjectProblem.fromMap(item);
      projectProblems.add(projectProblem);
    }

    List<Problem> problems = [];
    var secondResult =
        await db.rawQuery('SELECT * FROM Problem ORDER BY place');
    for (Map<String, dynamic> item in secondResult) {
      Problem problem = new Problem.fromMap(item);
      if (projectProblems.where((p) => p.problemId == problem.id).length != 0) {
        problem.selected = true;
      } else {
        problem.selected = false;
      }

      problems.add(problem);
    }

    return problems;
  }

  Future<List<Skill>> getAllSkillsForProjectTaskById(int projectTaskId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM ProjectTaskSkill WHERE projectTaskId = "$projectTaskId"');
    List<ProjectTaskSkill> projectTaskSkills = [];

    for (Map<String, dynamic> item in result) {
      ProjectTaskSkill projectTaskSkill = new ProjectTaskSkill.fromMap(item);
      projectTaskSkills.add(projectTaskSkill);
    }

    List<Skill> skills = [];
    var secondResult = await db.rawQuery('SELECT * FROM Skill ORDER BY place');
    for (Map<String, dynamic> item in secondResult) {
      Skill skill = new Skill.fromMap(item);
      if (projectTaskSkills.where((p) => p.skillId == skill.id).length != 0) {
        skill.selected = true;
      } else {
        skill.selected = false;
      }

      skills.add(skill);
    }

    return skills;
  }

  Future<List<Skill>> getAllSkillsForRoutineTaskSettingById(
      int routineTaskId) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM RoutineTaskSettingSkill WHERE routineTaskSettingId = "$routineTaskId"');
    List<RoutineTaskSettingSkill> routineTaskSettingSkills = [];

    for (Map<String, dynamic> item in result) {
      RoutineTaskSettingSkill routineTaskSettingSkill =
          new RoutineTaskSettingSkill.fromMap(item);
      routineTaskSettingSkills.add(routineTaskSettingSkill);
    }

    List<Skill> skills = [];
    var secondResult = await db.rawQuery('SELECT * FROM Skill ORDER BY place');
    for (Map<String, dynamic> item in secondResult) {
      Skill skill = new Skill.fromMap(item);
      if (routineTaskSettingSkills.where((p) => p.skillId == skill.id).length !=
          0) {
        skill.selected = true;
      } else {
        skill.selected = false;
      }

      skills.add(skill);
    }

    return skills;
  }

//################USER##################################
  /// Get a user
  Future<User> getUser() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM User');
    if (result.length == 0) return null;
    return new User.fromMap(result[0]);
  }

  Future<List<Skill>> getSkillsForGraph(int amount) async {
    var db = await _getDb();
    var result =
        await db.rawQuery('SELECT * FROM Skill ORDER BY place LIMIT $amount');
    if (result.length == 0) return [];

    List<Skill> skills = [];

    for (Map<String, dynamic> item in result) {
      Skill skill = new Skill.fromMap(item);
      skills.add(skill);
    }
    return skills;
  }

  Future<List<User>> getUsers() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM User');
    if (result.length == 0) return [];

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
          'REPLACE INTO User (id, identityId, firstName, image, configured, amountOfSkills) VALUES("${user.id}", "${user.identiyId}", "${user.firstName}", "${user.image}", "${user.configured}", "${user.amountOfSkills}")');
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
          'REPLACE INTO Project (id, title, place, description, priority, image_local, imagePath, totalPoints, completedPoints, completed, started, lastUpdated) VALUES("${project.id}", "${project.title}", "${project.place}", "${project.description}", "${project.priority}", "${project.imagePathLocal}", "${project.imagePathServer}", "${project.totalPoints}", "${project.completedPoints}", "${project.completed}", "${project.started}", "${project.lastUpdated}")');
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
        "SELECT pt.id, pt.title, pt.description, pt.completed, pt.started, pt.completed, pt.priority, pt.points, pt.userId, pt.milestoneId, pt.projectId FROM ProjectTask pt INNER JOIN Project p on p.id = pt.projectId WHERE (pt.completed == 'null' AND pt.started == 'null') OR (pt.completed == 'null' AND CAST(strftime('%s', pt.started) AS integer) > CAST(strftime('%s', datetime('now','localtime')) AS integer)) ORDER BY p.place, pt.place LIMIT 15");
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

  Future<List<ProjectTask>> getQueriedExistingTasksForToday(String search) async {
    List<ProjectTask> tasks = [];
 
    var projectResult = await db.rawQuery(
        "SELECT pt.id, pt.title, pt.place, pt.description, pt.completed, pt.started, pt.completed, pt.priority, pt.points, pt.userId, pt.milestoneId, pt.projectId FROM ProjectTask pt INNER JOIN Project p on p.id = pt.projectId WHERE pt.completed == 'null' AND pt.started == 'null' AND (pt.title LIKE '%$search%' OR pt.description LIKE '%$search%' OR p.title LIKE '%$search%') ORDER BY p.place, pt.place LIMIT 15");
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
        "SELECT pt.id, pt.title, pt.place, pt.description, pt.completed, pt.started, pt.completed, pt.priority, pt.points, pt.userId, pt.milestoneId, pt.projectId FROM ProjectTask pt INNER JOIN Project p on p.id = pt.projectId WHERE pt.completed == 'null' AND pt.started == 'null' ORDER BY p.place, pt.place LIMIT 15");
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
      "SELECT pt.id, pt.title, pt.place, pt.description, pt.completed, pt.started, pt.completed, pt.priority, pt.points, pt.userId, pt.milestoneId, pt.projectId FROM ProjectTask pt INNER JOIN Project p on p.id = pt.projectId WHERE pt.completed == 'null' AND CAST(strftime('%s', pt.started) AS integer) <= CAST(strftime('%s', datetime('now','localtime')) AS integer) ORDER BY pt.place asc");
    if (result.isEmpty) {
      return [];
    }
    List<ProjectTask> tasks = [];
    var counter = 0;
    for (Map<String, dynamic> item in result) {
      ProjectTask task = new ProjectTask.fromMap(item);
      task.place = counter;
      task.project = await getProject(task.projectId);
      tasks.add(task);
      counter++;
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
  Future deleteAllEverything() async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectTask');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTask');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM MileStone');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSetting');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM UserProject');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Project');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM LoggedInUser');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Token');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Problem');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Skill');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSettingSkill');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSkill');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectTaskSkill');
    });

    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectProblem');
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
        .rawQuery('SELECT imagePath FROM Project WHERE id = "${projectId}"');
    if (result.isNotEmpty) return result.single["imagePath"];

    return "";
  }

  /// Inserts or replaces the projectTask.
  Future updateProjectTask(ProjectTask projectTask) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO ProjectTask (${Task.db_id}, ${Task.db_title}, ${Task.db_description}, ${Task.db_started}, ${Task.db_completed}, ${ProjectTask.db_projectId}, ${ProjectTask.db_priority}, ${Task.db_points}, ${ProjectTask.db_milestoneId}, ${Task.db_place}, ${ProjectTask.db_userId}) VALUES("${projectTask.id}", "${projectTask.title}", "${projectTask.description}", "${projectTask.started}", "${projectTask.completed}", "${projectTask.projectId}", "${projectTask.priority}", "${projectTask.points}", "${projectTask.milestoneId}", "${projectTask.place}", "${projectTask.userId}")');
      print(id.toString());
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

  Future<String> getImageSkill(Skill skill) async {
    var db = await _getDb();
    var result =
        await db.rawQuery("SELECT * FROM Skill Where id = ${skill.id}");
    if (result.isEmpty) {
      return null;
    }

    return new Skill.fromMap(result.first).imagePathServer;
  }

  Future<String> getImageProblem(Problem problem) async {
    var db = await _getDb();
    var result =
        await db.rawQuery("SELECT * FROM Problem Where id = ${problem.id}");
    if (result.isEmpty) {
      return null;
    }

    return new Problem.fromMap(result.first).imagePath;
  }

  Future<List<Skill>> getSkills() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM Skill ORDER BY place");
    if (result.isEmpty) {
      return [];
    }
    List<Skill> skills = [];

    for (Map<String, dynamic> item in result) {
      Skill skill = new Skill.fromMap(item);
      skills.add(skill);
    }
    return skills;
  }

  Future<List<Skill>> getUnselectedSkills() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM Skill ORDER BY place");
    if (result.isEmpty) {
      return [];
    }
    List<Skill> skills = [];

    for (Map<String, dynamic> item in result) {
      Skill skill = new Skill.fromMap(item);
      skill.selected = false;
      skills.add(skill);
    }
    return skills;
  }

  Future<List<Problem>> getProblems() async {
    var db = await _getDb();
    var result = await db.rawQuery("SELECT * FROM Problem ORDER BY place");
    if (result.isEmpty) {
      return [];
    }
    List<Problem> problems = [];

    for (Map<String, dynamic> item in result) {
      Problem problem = new Problem.fromMap(item);
      problems.add(problem);
    }
    return problems;
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

  /// Delete routineTaskSetting from the local database by id
  /// param: routine task setting id
  Future deleteRoutineTaskSettingById(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSetting WHERE id = $id');
    });
  }

  /// Delete routineTaskSetting from the local database by id
  /// param: routine task setting id
  Future deleteRoutineTaskByIdAsync(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTask WHERE id = $id');
    });
  }

  /// Delete project task from the local database by id
  /// param: project task id
  Future deleteProjectTaskByIdAsync(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectTask WHERE id = $id');
    });
  }

  /// Delete projectTask from the local database by project id
  /// param: project id
  Future deleteProjectTasksByProjectIdAsync(int projectId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn
          .rawInsert('DELETE FROM ProjectTask WHERE projectId = $projectId');
    });
  }

  /// Delete milestones from the local database by project id
  /// param: project id
  Future deleteMileStonesByProjectIdAsync(int projectId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM MileStone WHERE projectId = $projectId');
    });
  }

  /// Delete milestone from the local database by id
  /// param: milestone id
  Future deleteMileStoneAsync(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM MileStone WHERE id = $id');
    });
  }

  /// Delete milestones from the local database by project id
  /// param: project id
  Future deleteProjectByIdAsync(int projectId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Project WHERE id = $projectId');
    });
  }

  /// Delete skills from the local database by id
  /// param: skill id
  Future deleteSkillByIdAsync(int skillId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Skill WHERE id = $skillId');
    });
  }

  /// Delete projectProblem from the local database by id
  /// param: projectProblem id
  Future deleteProjectProblemById(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectProblem WHERE id = $id');
    });
  }

  /// Delete projectTaskSkill from the local database by id
  /// param: projectTaskSkill id
  Future deleteProjectTaskSkillById(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM ProjectTaskSkill WHERE id = $id');
    });
  }

  /// Delete routineTaskSkill from the local database by id
  /// param: routineTaskSkill id
  Future deleteRoutineTaskSkillById(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSkill WHERE id = $id');
    });
  }

  /// Delete routineTaskSettingSkill from the local database by id
  /// param: routineTaskSettingSkill id
  Future deleteRoutineTaskSettingSkillById(int id) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM RoutineTaskSettingSkill WHERE id = $id');
    });
  }

  /// Delete problem from the local database by id
  /// param: problem id
  Future deleteProblemByIdAsync(int problemId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM Problem WHERE id = $problemId');
    });
  }

  /// Delete milestones from the local database by project id
  /// param: project id
  Future deleteUsersFromProjectByProjectIdAsync(int projectId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn
          .rawInsert('DELETE FROM UserProject WHERE projectId = $projectId');
    });
  }

  /// Delete projectTask from the local database by milestone id
  /// param: milestone id
  Future deleteProjectTasksByMileStoneIdAsync(int milestoneId) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.rawInsert(
          'DELETE FROM ProjectTask WHERE milestoneId = $milestoneId');
    });
  }

  /// Inserts or replaces the Master.
  Future updateMaster(Master master) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO Master (id, name, userId) VALUES("${master.id}", "${master.name}", "${master.userId}")');
    });
  }

  /// Inserts or replaces the Master.
  Future updateProblem(Problem problem) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO Problem (id, name, description, imagePath, place, points, userId, masterId) VALUES("${problem.id}", "${problem.name}", "${problem.description}", "${problem.imagePath}", "${problem.place}", "${problem.points}", "${problem.userId}", "${problem.masterId}")');
    });
  }

  /// Inserts or replaces the Reason.
  Future updateReason(Reason reason) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO Reason (id, name, userId, masterId) VALUES("${reason.id}", "${reason.name}", "${reason.userId}", "${reason.masterId}")');
    });
  }

  /// Inserts or replaces the Skill.
  Future updateSkill(Skill skill) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'REPLACE INTO Skill (id, title, description, imagePath, place, points, userId, masterId, problemId) VALUES("${skill.id}", "${skill.title}", "${skill.description}", "${skill.imagePathServer}", "${skill.place}", "${skill.points}", "${skill.userId}", "${skill.masterId}", "${skill.problemId}")');
    });
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
