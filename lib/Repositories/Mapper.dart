import 'package:peaky_blinders/Models/ChartData.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/ErrorLog.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTaskSkill.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/RoutineTaskSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/UserProject.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Token.dart';
import 'package:peaky_blinders/Models/User.dart';

class Mapper {
  static T fromMap<T>(Map<String, dynamic> map) {
    if (T == ProjectTask) {
      return ProjectTask.fromMap(map) as T;
    } else if (T == Project) {
      return Project.fromMap(map) as T;
    } else if (T == User) {
      return User.fromMap(map) as T;
    } else if (T == Token) {
      return Token.fromMap(map) as T;
    } else if (T == UserProject) {
      return UserProject.fromMap(map) as T;
    } else if (T == ChartData) {
      return ChartData.fromMap(map) as T;
    } else if (T == Device) {
      return Device.fromMap(map) as T;
    } else if (T == MileStone) {
      return MileStone.fromMap(map) as T;
    } else if (T == RoutineTaskSetting) {
      return RoutineTaskSetting.fromMap(map) as T;
    } else if (T == RoutineTask) {
      return RoutineTask.fromMap(map) as T;
    } else if (T == Skill) {
      return Skill.fromMap(map) as T;
    } else if (T == Problem) {
      return Problem.fromMap(map) as T;
    } else if (T == ProjectProblem) {
      return ProjectProblem.fromMap(map) as T;
    } else if (T == ProjectTaskSkill) {
      return ProjectTaskSkill.fromMap(map) as T;
    } else if (T == RoutineTaskSkill) {
      return RoutineTaskSkill.fromMap(map) as T;
    } else if (T == RoutineTaskSettingSkill) {
      return RoutineTaskSettingSkill.fromMap(map) as T;
    } else if (T == ErrorLog) {
      return ErrorLog.fromMap(map) as T;
    }

    return null;
  }
}
