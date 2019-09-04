import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';
import 'package:peaky_blinders/Repositories/ProjectRepository.dart';
import 'package:peaky_blinders/Repositories/TvRepository.dart';
import 'package:peaky_blinders/Repositories/UserRepository.dart';
import 'package:http/http.dart' as http;

class TVBloc implements BlocBase {
  bool existingProject = false;
  Project project;
  List<MileStone> milestones;
  List<User> users;
  Device _device;
  User owner;
  String projectName;
  String projectImage;
  MileStone selectedMilestone;
  ProjectTask selectedProjectTask;
  int milestoneCounter;
  int taskCounter;

  StreamController<List<MileStone>> _milestoneController =
      StreamController<List<MileStone>>.broadcast();
  StreamSink<List<MileStone>> get _inMileStone => _milestoneController.sink;
  Stream<List<MileStone>> get outMileStone => _milestoneController.stream;

  StreamController<List<Device>> _deviceController =
      StreamController<List<Device>>.broadcast();
  StreamSink<List<Device>> get _inDevice => _deviceController.sink;
  Stream<List<Device>> get outDevice => _deviceController.stream;

  StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUser => _userController.sink;
  Stream<List<User>> get outUser => _userController.stream;

  StreamController<List<User>> _unselectedUserController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUnselectedUser =>
      _unselectedUserController.sink;
  Stream<List<User>> get outUnselectedUser => _unselectedUserController.stream;

  //
  // Constructor
  //
  TVBloc() {
    milestones = [];
    users = [];
    projectName = "";
    projectImage = "";
    milestoneCounter = 0;
    taskCounter = 0;
  }

  @override
  void dispose() {
    _milestoneController.close();
  }

  void setDevice(device) {
    _device = device;
  }

  void getDevices() async {
    if (_device == null) {
      _inDevice.add(await ProjectRepository.get().getDevices());
    }
  }

  Future getAllUnselectedUsers() async {
    List<User> unselectedUsers = [];
    List<User> allUsers = await UserRepository.get().getUsers();

    for (int i = 0; i < allUsers.length; i++) {
      if (users.where((u) => u.id == allUsers[i].id).length == 0) {
        User user = allUsers[i];
        user.selected = false;
        unselectedUsers.add(user);
      }
    }
    _inUnselectedUser.add(unselectedUsers);
  }

  Future<List<MileStone>> getMilestonesForProject(projectId) async {
    return await MileStoneRepository.get().getMilestonesByProjectId(projectId);
  }

  void updateUser(user) {
    if (owner == user) {
      return;
    }

    if (users.where((u) => u.id == user.id).isEmpty) {
      users.add(user);
    } else {
      users.removeWhere((u) => u.id == user.id);
    }
  }

  void addUser(user) {
    users.add(user);
  }

  void addMileStone() {}

  void removeMileStone() {}

  void setOwner() async {
    users = [];
    owner = await UserRepository.get().getLoggedInUser();
    owner.selected = true;
    users.add(owner);
  }

  void getUsersTv() async {
    _inUser.add(users);
  }

  Future updateMileStonesToTv() async {
    List<Map<String, dynamic>> mappedMileStones = [];
    for (MileStone milestone in milestones) {
      mappedMileStones.add(milestone.toMap());
    }

    String jsonMap = jsonEncode(mappedMileStones);

    await TvRepository.get().updateTv("milestones", jsonMap, _device.socketId);
  }

  String getImageFromProject(image) {
    return ProjectRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  List<MileStone> getMileStones() {
    return milestones;
  }

  void createMileStone() {
    MileStone milestone = new MileStone();
    milestone.id = 0;
    milestone.title = "New Milestone";
    milestone.place = milestoneCounter;
    milestoneCounter++;
    milestone.tasks = [];
    milestones.add(milestone);
  }

  Future updateNameToTv() async {
    if (_device != null) {
      await TvRepository.get()
          .updateTv("project", projectName, _device.socketId);
    }
  }

  Future updateMilestoneToTv() async {
    if (_device != null) {
      await TvRepository.get().updateTv(
          "milestone",
          jsonEncode(
              selectedMilestone != null ? selectedMilestone.toMap() : null),
          _device.socketId);
    }
  }

  Future updateTaskToTv() async {
    if (_device != null) {
      await TvRepository.get().updateTv(
          "task",
          jsonEncode(
              selectedProjectTask != null ? selectedProjectTask.toMap() : null),
          _device.socketId);
    }
  }

  Future updateUsersToTv() async {
    List<Map<String, dynamic>> mappedUsers = [];
    for (User user in users) {
      mappedUsers.add(user.toMap());
    }

    String jsonMap = jsonEncode(mappedUsers);

    if (_device != null) {
      await TvRepository.get().updateTv("users", jsonMap, _device.socketId);
    }
  }

  Future uploadImage(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(TvRepository.get().weburl + "api/Projects/uploadImage");

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

    //listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      if (value != null) {
        projectImage = value;
        await updateImageToTv();
      }
    });
  }

  Future saveProject() async {
    if (existingProject) {
      project.title = projectName;
      project.imagePathServer = projectImage;
      project.milestones = milestones;
      project.users = users;
      for (int i = 0; i < project.milestones.length; i++) {
        project.milestones[i].projectId = project.id;
      }
      await ProjectRepository.get().updateProject(project);
    } else {
      Project project =
          new Project(totalPoints: 0, completedPoints: 0, priority: "Trivial");

      project.imagePathServer = projectImage;
      project.title = projectName;

      project.milestones = milestones;
      project.users = users;
      await ProjectRepository.get().postProjectFromTv(project);
    }

    cleanseTvCache();
  }

  void cleanseTvCache() {
    projectImage = "";
    projectName = "";
    milestones = [];
    selectedMilestone = null;
    selectedProjectTask = null;
    milestoneCounter = 0;
    existingProject = false;
  }

  Future updateImageToTv() async {
    if (_device != null) {
      await TvRepository.get()
          .updateTv("image", projectImage, _device.socketId);
    }
  }

  Future navigateToTaskBoardTv() async {
    if (_device != null) {
      await TvRepository.get().updateTv("taskBoard", "", _device.socketId);
    }
  }

  Future navigateToProjectBoardTv() async {
    if (_device != null) {
      await TvRepository.get().updateTv("projectBoard", "", _device.socketId);
    }
  }

  Future updateTasksToTv() async {
    List<Map<String, dynamic>> mappedTasks = [];
    for (ProjectTask task in selectedMilestone.tasks) {
      mappedTasks.add(task.toMap());
    }

    String jsonMap = jsonEncode(mappedTasks);

    if (_device != null) {
      await TvRepository.get().updateTv("tasks", jsonMap, _device.socketId);
    }
  }
}
