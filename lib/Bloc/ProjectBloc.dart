import 'dart:async';
import 'dart:io';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/ProjectRepository.dart';

class ProjectBloc implements BlocBase {
  List<Project> _projects;
  Project _currentProject;
  Project _defaultProject;
  List<User> users;
  Device _device;
  int milestoneCounter;
  int taskCounter;
  int projectsCounter;
  MileStone selectedMilestone;
  ProjectTask selectedProjectTask;

  StreamController<List<Device>> _deviceController =
      StreamController<List<Device>>.broadcast();
  StreamSink<List<Device>> get _inDevice => _deviceController.sink;
  Stream<List<Device>> get outDevice => _deviceController.stream;

  StreamController<List<Project>> _projectController =
      StreamController<List<Project>>.broadcast();
  StreamSink<List<Project>> get _inProject => _projectController.sink;
  Stream<List<Project>> get outProject => _projectController.stream;

  StreamController<List<ProjectDropdown>> _projectDropdownController =
      StreamController<List<ProjectDropdown>>.broadcast();
  StreamSink<List<ProjectDropdown>> get _inProjectDropdown =>
      _projectDropdownController.sink;
  Stream<List<ProjectDropdown>> get outProjectDropdown =>
      _projectDropdownController.stream;

  StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUser => _userController.sink;
  Stream<List<User>> get outUser => _userController.stream;

  StreamController<List<User>> _unselectedUserController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUnselectedUser =>
      _unselectedUserController.sink;
  Stream<List<User>> get outUnselectedUser => _unselectedUserController.stream;

  StreamController _actionController = StreamController();
  StreamSink get fetchProject => _actionController.sink;

  //
  // Constructor
  //
  ProjectBloc() {
    ProjectRepository.get().syncProjects();
    milestoneCounter = 0;
    taskCounter = 0;
    projectsCounter = 0;
  }

  void setCurrentProject(Project project) {
    this._currentProject = project;
  }

  void updateCurrentProject(image) {
    if (image != null) {
      ProjectRepository.get().upload(image, _currentProject.id);
    }
    ProjectRepository.get().updateProject(_currentProject);
    ProjectRepository.get().syncProjects();
  }

  void setDevice(device) {
    _device = device;
  }

  Project getCurrentProject() {
    return _currentProject;
  }

  int getProjectId() {
    return _currentProject.id;
  }

  postProject(File image, User user) async {
    ProjectRepository.get().postProject(_currentProject, image, user);
    ProjectRepository.get().syncProjects();
  }

  Project getDefaultProject() {
    return _defaultProject;
  }

  void getDropdownProject() async {
    _inProjectDropdown.add(await ProjectRepository.get().getProjectDropdown());
  }

  Future<Project> getProjectById(projectId) async {
    return await ProjectRepository.get().getProject(projectId);
  }

  Future<Project> getProjectWithMilestoneById(projectId) async {
    return await ProjectRepository.get().getProjectWithMilestones(projectId);
  }

  Future<Project> getFirstProject() async {
    return await ProjectRepository.get().getFirstProject();
  }

  void updateUser(user) {
    if (users.where((u) => u.id == user.id).single.selected == true) {
      users.where((u) => u.id == user.id).single.selected = false;
    } else {
      users.where((u) => u.id == user.id).single.selected = true;
    }
  }

  void updateNewUsersToProject() {
    List<User> selectedUsers = [];
    for (User user in users) {
      if (user.selected) {
        selectedUsers.add(user);
      }
    }
    ProjectRepository.get()
        .setUsersToProject(selectedUsers, _currentProject.id);
  }

  Future syncCurrentProject() async {
    await ProjectRepository.get().syncProject(_currentProject.id);
    _currentProject =
        await ProjectRepository.get().getProject(_currentProject.id);
  }

  Future syncProjects() async {
    await ProjectRepository.get().syncProjects();
  }

  Future syncEverything() async {
    await ProjectRepository.get().syncEverything();
  }

  void createMileStone() {
    MileStone milestone = new MileStone(
        title: "new Milestone", tasks: [], place: milestoneCounter);
    this._currentProject.milestones.add(milestone);
    milestoneCounter++;
  }

  void dispose() {
    _actionController.close();
    _projectController.close();
    _userController.close();
  }

  String getImageFromServer(image) {
    return ProjectRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  Future getUsers() async {
    _inUser.add(
        await ProjectRepository.get().getUsersByProjectId(_currentProject.id));
  }

  Future getUnselectedUsers() async {
    _inUnselectedUser.add(await ProjectRepository.get()
        .getAllUnselectedUsersByProjectId(_currentProject.id));
  }

  Future syncUnselectedUsers() async {
    users = await ProjectRepository.get()
        .getAllUnselectedUsersByProjectId(_currentProject.id);
  }

  Future getDevices() async {
    if (_device == null) {
      _inDevice.add(await ProjectRepository.get().getDevices());
    }
  }

  Future getProjects() async {
    _inProject.add(await ProjectRepository.get().getProjects());
  }

  Future setProjectCount() async {
    projectsCounter = await ProjectRepository.get().getProjectCount();
  }

  int getProjectCount() {
    return projectsCounter;
  }
}
