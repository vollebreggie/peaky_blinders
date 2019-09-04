import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/ChartData.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/UserRepository.dart';

class UserBloc implements BlocBase {
  List<User> _users;
  List<ChartData> list;
  User _user;
  int completedTask = 0;
  int completedPointsToday = 0;
  int completedTaskToday = 0;
  int completedPoints = 0;
  String id = "";
  //
  // Stream to handle the counter
  //
  StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _inUser => _userController.sink;
  Stream<List<User>> get outUser => _userController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get fetchUser => _actionController.sink;

  //
  // Constructor
  //
  UserBloc() {
    //UserRepository.get().syncUsers();
    //_actionController.stream.listen(_handleLogic);
  }

  User getUser() {
    return _user;
  }

  void setUserId(id) {
    this.id = id;
  }

  Future getCompletedTasks() async {
    await UserRepository.get()
        .getCompletedTasks()
        .then((count) => completedTask = count);
  }

  Future getCompletedTasksToday() async {
    await UserRepository.get()
        .getCompletedTasksToday()
        .then((count) => completedTaskToday = count);
  }

  Future getPointsGainedToday() async {
    await UserRepository.get()
        .getPointsGainedToday()
        .then((count) => completedPointsToday = count);
  }

  Future getCompletedPoints() async {
    await UserRepository.get()
        .getCompletedPoints()
        .then((count) => completedPoints = count);
  }

  Future getChartData() async {
    list = await UserRepository.get().getChartData();
  }

  Future logout() async {
    await UserRepository.get().deleteEveryting();
  }

  void uploadUserImage(image, userId) {
    UserRepository.get().uploadUserImage(image, userId);
  }

  String getImageFromServer(image) {
    return UserRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  void dispose() {
    _actionController.close();
    _userController.close();
  }

  Future<bool> login(name, password) async {
    bool success = await UserRepository.get().login(name, password);
    if (success) {
      _user = await UserRepository.get().getLoggedInUser();
    }
    return success;
  }

  Future getUsers() async {
    _inUser.add(await UserRepository.get().getUsers());
  }

  Future setUser() async {
    _user = await UserRepository.get().getLoggedInUser();
  }

  // void _handleLogic(data) async {
  //   // _user = await Repository.get().getUser(id);
  //   _user = await Repository.get().getUserLocal();

  //   _inUser.add(await Repository.get().getUsers());
  // }
}
