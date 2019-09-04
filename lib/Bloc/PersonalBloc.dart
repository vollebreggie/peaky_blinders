import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/PersonalRepository.dart';

class PersonalBloc implements BlocBase {
  User _user;
  List<Master> _masters;
  int _masterCounter;
  int _problemCounter;

  PersonalBloc() {
    _masters = [];
    _masterCounter = 0;
    _problemCounter = 0;
  }

  StreamController<List<Skill>> _skillController =
      StreamController<List<Skill>>.broadcast();
  StreamSink<List<Skill>> get _inSkill => _skillController.sink;
  Stream<List<Skill>> get outSkill => _skillController.stream;

  void getSkills() {
    _inSkill.add(getCurrentProblem().skills);
  }

  void getPersonalSkills() {
    _inSkill.add(getCurrentPersonalProblem().skills);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  /// Add master to private list of masters
  void addMaster(Master master) {
    _masters.add(master);
  }

  String capitalize(String input) {
    if (input == null) {
      throw new ArgumentError("string: $input");
    }
    if (input.length == 0) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  Master getCurrentMaster() {
    return _masters[_masterCounter];
  }

  void resetProblemCounter() {
    _problemCounter = 0;
  }

  Problem getCurrentProblem() {
    return getCurrentMaster().problems[_problemCounter];
  }

  Problem getCurrentPersonalProblem() {
    return getUser().problems[_problemCounter];
  }

  // Skill getCurrentSkill() {
  //   return getCurrentProblem().skills
  // }

  /// Set logged in user
  void setUser(User user) {
    _user = user;
  }

  /// Get logged in user
  User getUser() {
    return _user;
  }

  /// Create master with only his/her name
  Master createMaster(String name) {
    print("sup");
    return new Master(
        id: 0,
        name: name,
        user: null,
        userId: _user.id,
        reasons: [],
        problems: []);
  }

  Reason createReason(String name) {
    return new Reason(
        id: 0,
        name: name,
        master: null,
        masterId: 0,
        user: null,
        userId: _user.id);
  }

  Future sendPersonalData() async {
    _user.masters = _masters;
    for (int i = 0; i < _user.problems.length; i++) {
      _user.problems[i].id = 0;
      _user.problems[i].place = i;
      _user.problems[i].masterId = null;
      for (int j = 0; j < _user.problems[i].skills.length; j++) {
        _user.problems[i].skills[j].place = j;
        _user.problems[i].skills[j].id = 0;
        _user.problems[i].skills[j].masterId = null;
      }
    }
    await PersonalRepository.get().sendIntroData(_user);

  }

  void setNextMaster() {
    _masterCounter++;
  }

  bool continueWithMasters() {
    return _masterCounter == 2 ? false : true;
  }

  bool continueWithProblem() {
    return _problemCounter == 2 ? false : true;
  }

  int getProblemCounter() {
    return _problemCounter;
  }

  int getMasterCounter() {
    return _masterCounter;
  }

  void nextProblem() {
    _problemCounter++;
  }

  Problem createProblem(String name) {
    Skill skill = createSkill("");
    Problem problem = new Problem(
        id: 0,
        name: name,
        points: 0,
        master: null,
        masterId: 0,
        user: null,
        userId: _user.id,
        imagePath: "example.jpg",
        skills: []);
    problem.skills.add(skill);
    return problem;
  }

  Problem createProblemWithId(String name, int id) {
    Skill skill = createSkillWithId("", 1);
    Problem problem = new Problem(
        id: id,
        points: 0,
        name: name,
        master: null,
        masterId: 0,
        user: null,
        userId: _user.id,
        imagePath: "example.jpg",
        skills: []);
    problem.skills.add(skill);
    return problem;
  }

  Skill createSkillWithId(String title, int id) {
    return new Skill(
        id: id,
        title: title,
        master: null,
        points: 0,
        masterId: 0,
        user: null,
        userId: _user.id,
        imagePathServer: "example.jpg");
  }

  Skill createSkill(String title) {
    return new Skill(
        id: 0,
        title: title,
        master: null,
        masterId: 0,
        points: 0,
        user: null,
        userId: _user.id,
        imagePathServer: "example.jpg");
  }
}
