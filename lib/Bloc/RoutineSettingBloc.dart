import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Repositories/RoutineSettingRepository.dart';
import 'package:peaky_blinders/Repositories/SkillRepository.dart';

class RoutineSettingBloc implements BlocBase {
  List<RoutineTaskSetting> _routineSettings;
  RoutineTaskSetting _routineSetting;
  List<Skill> selectedSkills;
  List<Skill> skills;

  StreamController<List<Skill>> _skillController =
      StreamController<List<Skill>>.broadcast();
  StreamSink<List<Skill>> get _inSkill => _skillController.sink;
  Stream<List<Skill>> get outSkill => _skillController.stream;

  RoutineSettingBloc() {
    _routineSettings = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future syncRoutineSettings() async {
    await RoutineSettingRepository.get().syncProjectSettings();
  }

  Future setRoutineSettings() async {
    _routineSettings =
        await RoutineSettingRepository.get().getRoutineSettings();
  }

  List<RoutineTaskSetting> getRoutineTaskSettings() {
    return _routineSettings;
  }

  void getSelectedSkill() {
    if (_routineSetting != null) {
      _inSkill.add(_routineSetting.skills);
    }
  }

  Future saveRoutineTask(RoutineTaskSetting task) async {
    await RoutineSettingRepository.get().createRoutineTask(task);
  }

  Future setRoutineTaskSettingSkill(
      RoutineTaskSettingSkill routineTaskSettingSkill) async {
    await RoutineSettingRepository.get()
        .setRoutineTaskSettingSkill(routineTaskSettingSkill);
  }

  Future updateRoutineTask(RoutineTaskSetting task) async {
    await RoutineSettingRepository.get().updateRoutineTask(task);
  }

  Future changePriorityOfRoutineTask(before, after) async {
    RoutineTaskSetting task = _routineSettings[before];
    _routineSettings.removeAt(before);
    _routineSettings.insert(after, task);
    for (int i = 0; i < _routineSettings.length; i++) {
      _routineSettings[i].place = i;
    }

    await RoutineSettingRepository.get().changePriorityTasks(_routineSettings);
  }

  void setRoutineTask(RoutineTaskSetting task) {
    _routineSetting = task;
  }

  /// Removed routine setting completely from the server and database
  Future deleteRoutineSettingsTask(
      RoutineTaskSetting routineTaskSetting) async {
    await RoutineSettingRepository.get()
        .deleteRoutineSetting(routineTaskSetting);
    await setRoutineSettings();
  }

  Future getCreateSkills() async {
    if (selectedSkills != null) {
      _inSkill.add(selectedSkills);
    }
  }

  void setRoutineCreateSkill(Skill skill) {
    if (selectedSkills.where((p) => p.id == skill.id).isEmpty) {
      selectedSkills.add(skill);
    } else {
      selectedSkills.removeWhere((s) => s.id == skill.id);
    }
    _routineSetting.skills = selectedSkills;
  }

  void setAllSkillsByCreateRoutine(Skill skill) {
    if (skills[skills.indexOf(skill)].selected) {
      skills[skills.indexOf(skill)].selected = false;
    } else {
      skills[skills.indexOf(skill)].selected = true;
    }
  }

  RoutineTaskSetting getRoutineTask() {
    return _routineSetting;
  }
}
