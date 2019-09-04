import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/Skill.dart';

class ProjectTaskSkill {
  int id;
  ProjectTask projectTask;
  int projectTaskId;
  Skill skill;
  int skillId;

  ProjectTaskSkill(
      {this.id,
      this.projectTask,
      this.projectTaskId,
      this.skill,
      this.skillId});

  ProjectTaskSkill.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            projectTaskId: map["projectTaskId"],
            skillId: map["skillId"],
            skill: map["skill"] != null ? Skill.fromMap(map["skill"]) : null,
            projectTask: map["projectTask"] != null
                ? ProjectTask.fromMap(map["projectTask"])
                : null);

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "projectTaskId": projectTaskId,
      "skillId": skillId,
      "id": id,
      "projectTask": projectTask != null ? projectTask.toMap() : null,
      "skill": skill != null ? skill.toMap() : null
    };
  }
}
