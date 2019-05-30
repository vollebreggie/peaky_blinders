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
    UserRepository.get().syncUsers();
    //_actionController.stream.listen(_handleLogic);
  }

  User getUser() {
    return _user;
  }
  
  void setUserId(id) {
    this.id = id;
  }

  Future getCompletedTasks() async{
     UserRepository.get().getCompletedTasks(_user.id).then((count) => completedTask = count);
  }

  Future getCompletedPoints() async {
     UserRepository.get().getCompletedPoints(_user.id).then((count) => completedPoints = count);
  }

  void getChartData() async{
    list = await UserRepository.get().getChartData(_user.id);
  }

  void uploadUserImage(image, userId){
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

  void login(name, password) async {
    await UserRepository.get().login(name, password);
    _user = await UserRepository.get().getLoggedInUser();
    getCompletedTasks();
    getCompletedPoints();
    getChartData();
  }

  void getUsers() async {
    _inUser.add(await UserRepository.get().getUsers());
  }
  
  // void _handleLogic(data) async {
  //   // _user = await Repository.get().getUser(id);
  //   _user = await Repository.get().getUserLocal();

  //   _inUser.add(await Repository.get().getUsers());
  // }
}
