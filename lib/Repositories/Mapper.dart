import 'package:peaky_blinders/Models/ChartData.dart';
import 'package:peaky_blinders/Models/Device.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
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
    }else if (T == ChartData) {
      return ChartData.fromMap(map) as T;
    }else if (T == Device) {
      return Device.fromMap(map) as T;
    }else if (T == MileStone) {
      return MileStone.fromMap(map) as T;
    }else if (T == RoutineTaskSetting) {
      return RoutineTaskSetting.fromMap(map) as T;
    }else if (T == RoutineTask) {
      return RoutineTask.fromMap(map) as T;
    }
    return null;
  }
}
