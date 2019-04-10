

import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/User.dart';

class UserBloc implements BlocBase {
  User _user;

  //
  // Stream to handle the counter
  //
  StreamController<User> _userController = StreamController<User>.broadcast();
  StreamSink<User> get _inUser => _userController.sink;
  Stream<User> get outUser => _userController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get fetchUser => _actionController.sink;

  //
  // Constructor
  //
  UserBloc() {
   
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionController.close();
    _userController.close();
  }

  void _handleLogic(data) async {
     _user = await Repository.get().getUser();
     _inUser.add(_user);
  }
}
