import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';

class RoutineTaskSettingSkill {
  int id;
  RoutineTaskSetting routineTaskSetting;
  int routineTaskSettingId;
  Skill skill;
  int skillId;

  RoutineTaskSettingSkill(
      {this.id,
      this.routineTaskSetting,
      this.routineTaskSettingId,
      this.skill,
      this.skillId});

  RoutineTaskSettingSkill.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            routineTaskSettingId: map["routineTaskSettingId"],
            skillId: map["skillId"],
            skill: map["skill"] != null ? Skill.fromMap(map["skill"]) : null,
            routineTaskSetting: map["routineTaskSetting"] != null
                ? RoutineTaskSetting.fromMap(map["routineTaskSetting"])
                : null);

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "routineTaskSettingId": routineTaskSettingId,
      "skillId": skillId,
      "id": id,
      "routineTaskSetting": routineTaskSetting != null ? routineTaskSetting.toMap() : null
    };
  }
}
