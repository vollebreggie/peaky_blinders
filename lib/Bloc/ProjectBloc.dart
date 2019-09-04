import 'dart:async';
import 'dart:io';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectDropdown.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';
import 'package:peaky_blinders/Repositories/ProblemRepository.dart';
import 'package:peaky_blinders/Repositories/ProjectRepository.dart';
import 'package:peaky_blinders/Repositories/TaskRepository.dart';

class ProjectBloc implements BlocBase {
  List<Project> _projects;
  Project _currentProject;
  Project _defaultProject;
  List<User> users;
  List<Problem> problems;
  List<Problem> selectedProblems;
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

  StreamController<List<Problem>> _problemController =
      StreamController<List<Problem>>.broadcast();
  StreamSink<List<Problem>> get _inProblems => _problemController.sink;
  Stream<List<Problem>> get outProblems => _problemController.stream;

  StreamController<List<User>> _unselectedUserController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUnselectedUser =>
      _unselectedUserController.sink;
  Stream<List<User>> get outUnselectedUser => _unselectedUserController.stream;

  StreamController<List<Problem>> _unselectedProblemController =
      StreamController<List<Problem>>.broadcast();
  StreamSink<List<Problem>> get _inUnselectedProblem =>
      _unselectedProblemController.sink;
  Stream<List<Problem>> get outUnselectedProblem =>
      _unselectedProblemController.stream;

  StreamController _actionController = StreamController();
  StreamSink get fetchProject => _actionController.sink;

  //
  // Constructor
  //
  ProjectBloc() {
    milestoneCounter = 0;
    taskCounter = 0;
    projectsCounter = 0;
  }

  void setCurrentProject(Project project) {
    this._currentProject = project;
  }

  Future updateCurrentProject(image) async {
    if (image != null) {
      await ProjectRepository.get().upload(image, _currentProject);
    } else {
      await ProjectRepository.get().updateProject(_currentProject);
    }
  }

  Future<String> getStringImageProject(int id) async {
    return await ProjectRepository.get().getProjectImage(id);
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
    _currentProject.problems = selectedProblems;
    await ProjectRepository.get().postProject(_currentProject, image, user);
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

  Future updateNewUsersToProject() async {
    List<User> selectedUsers = [];
    for (User user in users) {
      if (user.selected) {
        selectedUsers.add(user);
      }
    }
    await ProjectRepository.get()
        .setUsersToProject(selectedUsers, _currentProject.id);
  }

  Future updateNewProblemsToProject() async {
    List<Problem> selectedProblems = [];
    for (Problem problem in problems) {
      if (problem.selected) {
        selectedProblems.add(problem);
      }
    }
    await ProjectRepository.get()
        .setProblemsToProject(selectedProblems, _currentProject.id);
  }

  Future syncCurrentProject() async {
    await ProjectRepository.get().syncProject(_currentProject.id);
    _currentProject =
        await ProjectRepository.get().getProject(_currentProject.id);
  }

  // Future syncUnselectedProblems() async {
  //   problems = await ProjectRepository.get()
  //       .getAllUnselectedProblemsByProjectId(_currentProject.id);
  // }

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
    if (_currentProject != null) {
      _inUser.add(await ProjectRepository.get()
          .getUsersByProjectId(_currentProject.id));
    }
  }

  Future getProblems() async {
    if (_currentProject != null) {
      _inProblems.add(await ProblemRepository.get()
          .getSelectedProblemsByProjectId(_currentProject.id));
    }
  }

  Future getCreateProblems() async {
    if (selectedProblems != null) {
      _inProblems.add(selectedProblems);
    }
  }

  Future setProjectProblem(ProjectProblem projectProblem) async {
    await ProjectRepository.get().setProjectProblem(projectProblem);
  }

  void setAllProblemsByCreateProject(Problem problem) {
    if (problems[problems.indexOf(problem)].selected) {
      problems[problems.indexOf(problem)].selected = false;
    } else {
      problems[problems.indexOf(problem)].selected = true;
    }
  }

  void setProjectCreateProblem(Problem problem) {
    if (selectedProblems.where((p) => p.id == problem.id).isEmpty) {
      selectedProblems.add(problem);
    } else {
      selectedProblems.remove(problem);
    }
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

  /// Delete project, milestones and tasks on server and in the local database
  /// param: project object
  Future deleteProjectAsync(Project project) async {
    project.milestones =
        await MileStoneRepository.get().getMilestonesByProjectId(project.id);
    await TaskRepository.get().deleteProjectTaskByProjectAsync(project.id);
    await MileStoneRepository.get().deleteMileStoneByProjectIdAsync(project.id);
    await ProjectRepository.get()
        .deleteUsersFromProjectByProjectIdAsync(project.id);
    await ProjectRepository.get().deleteProjectByIdAsync(project.id);
  }
}
