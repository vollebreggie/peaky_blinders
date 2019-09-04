import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/User.dart';

class ProjectProblem {
  int id;
  Project project;
  int projectId;
  Problem problem;
  int problemId;

  ProjectProblem(
      {this.id, this.project, this.projectId, this.problem, this.problemId});

  ProjectProblem.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"],
            projectId: map["projectId"],
            problemId: map["problemId"],
            project:
                map["project"] != null ? Project.fromMap(map["project"]) : null,
            problem: map["problem"] != null
                ? Problem.fromMap(map["problem"])
                : null);

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "projectId": projectId,
      "problemId": problemId,
      "id": id,
      "project": project != null ? project.toMap() : null,
      "problem": problem != null ? problem.toMap() : null
    };
  }
}
