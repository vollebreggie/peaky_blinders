import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/PersonalRepository.dart';
import 'package:peaky_blinders/Repositories/SkillRepository.dart';
import 'package:peaky_blinders/widgets/spider_chart.dart';

class SkillBloc implements BlocBase {
  List<Skill> _skills;
  List<Skill> _graphSkills;
  Skill _skill;

  SkillBloc() {
    _skills = [];
  }

  StreamController<List<Skill>> _skillController =
      StreamController<List<Skill>>.broadcast();
  StreamSink<List<Skill>> get _inSkill => _skillController.sink;
  Stream<List<Skill>> get outSkill => _skillController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  List<Skill> getSkills() {
    return _skills;
  }

  void setSkill(Skill skill) {
    _skill = skill;
  }

  Skill getCurrentSkill() {
    return _skill;
  }

  Future syncSkill() async {
    await SkillRepository.get().syncSkills();
  }

  Future setSkills() async {
    this._skills = await SkillRepository.get().getSkills();
  }

  int getSkillCount() {
    return _skills.length;
  }

  String getImageFromServer(image) {
    return SkillRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  Future changePriorityOfSkill(before, after) async {
    Skill skill = _skills[before];
    _skills.removeAt(before);
    skill.place = after;
    _skills.insert(after, skill);
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].place = i;
    }
    await SkillRepository.get().changePrioritySkills(_skills);
  }

  Future syncSkillByTask(Task task) async {
    if (task.runtimeType == ProjectTask) {
      await SkillRepository.get().syncSkillsProjectTasksById(task.id);
    } else if (task.runtimeType == RoutineTask) {
      await SkillRepository.get().syncSkillsRoutineTasksById(task.id);
    }
  }

  Future syncSkills() async {
    await SkillRepository.get().syncSkillsProjectTasks();
    await SkillRepository.get().syncSkillsRoutines();
  }

  Future setAllSkillsByProjectTask(int projectTaskId) async {
    this._skills = await SkillRepository.get()
        .getAllSkillsForProjectTaskById(projectTaskId);
  }

  Future<List<Skill>> setAllSkillByNewProjectTask(selectedSkills) async {
    return await SkillRepository.get()
        .getAllSkillsBasedOnSelected(selectedSkills);
  }

  Future<List<Skill>> getAllSkillsForRoutineTaskSettingById(
      routineSettingId) async {
    return await SkillRepository.get()
        .getSelectedSkillsForRoutineTaskSettingById(routineSettingId);
  }

  Future getSkillsForGraph(int amount) async {
    _inSkill.add(await SkillRepository.get().getSkillsForGraph(amount));
  }

  SpiderChart createSkillWebGraph(List<Skill> skills) {
    List<double> data = [];
    List<String> names = [];
    List<Color> colors = [];
    double max = 0;
    for (Skill skill in skills) {
      if (skill.points > max) max = skill.points.toDouble();
      data.add(skill.points.toDouble());
      names.add(skill.title.length < 10
          ? skill.title
          : skill.title.substring(0, 8) + "..");
      colors.add(Color.fromRGBO(8, 68, 22, 1.0));
    }
    return SpiderChart(
        data: data, skills: names, maxValue: max, colors: colors);
  }

  Future updateCurrentImage() async{
    _skill.imagePathServer = await SkillRepository.get().getImageSkill(_skill);
  }

  Future updateSkill(File image, Skill skill) async {
    if (image == null) {
      await SkillRepository.get().updateSkill(skill);
    } else if (image != null) {
      await SkillRepository.get().uploadImageSkill(image, skill);
    }
  }

  Future<List<Skill>> setAllSkillByNewRoutineSetting(selectedSkills) async {
    return await SkillRepository.get()
        .getAllSkillsBasedOnSelected(selectedSkills);
  }

  Future<List<Skill>> getUnselectedSkills() async {
    return await SkillRepository.get().getUnselectedSkills();
  }

  Future setAllSkillsByRoutineTaskSetting(int routineTaskId) async {
    this._skills = await SkillRepository.get()
        .getAllSkillsForRoutineTaskSettingById(routineTaskId);
  }

  Future postSkill(File image, Skill skill) async {
    await SkillRepository.get().postSkillWithImage(image, skill);
  }

  Future createSkill(Skill skill) async {
    await SkillRepository.get().createSkill(skill);
    await setSkills();
  }

  Future removeSkill(Skill skill) async {
    _skills.removeWhere((s) => s.id == skill.id);
    await SkillRepository.get().removeSkill(skill);
  }
}
