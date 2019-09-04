import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Skill.dart';

class RoutineTaskSkill {
  int id;
  RoutineTask routineTask;
  int routineTaskId;
  Skill skill;
  int skillId;

  RoutineTaskSkill(
      {this.id,
      this.routineTask,
      this.routineTaskId,
      this.skill,
      this.skillId});

  RoutineTaskSkill.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            routineTaskId: map["routineTaskId"],
            skillId: map["skillId"],
            skill: map["skill"] != null ? Skill.fromMap(map["skill"]) : null,
            routineTask: map["routineTask"] != null
                ? RoutineTask.fromMap(map["routineTask"])
                : null);

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "routineTaskId": routineTaskId,
      "skillId": skillId,
      "id": id,
      "routineTask": routineTask != null ? routineTask.toMap() : null
    };
  }
}
