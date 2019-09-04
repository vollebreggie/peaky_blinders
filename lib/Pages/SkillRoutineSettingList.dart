import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/ProjectTaskSkill.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/RoutineTaskSettingSkill.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/ProblemPage.dart';
import 'package:peaky_blinders/Pages/SkillPage.dart';
import 'package:peaky_blinders/Pages/TaskPage.dart';
import 'package:peaky_blinders/widgets/TomorrowProjectTaskWidget.dart';
import 'package:peaky_blinders/widgets/TomorrowRoutineTaskWidget.dart';
import 'package:peaky_blinders/widgets/createProjectProblemWidget.dart';
import 'package:peaky_blinders/widgets/createTaskSkillWidget.dart';

class SkillRoutineSettingListPage extends StatefulWidget {
  @override
  _SkillRoutineSettingListState createState() =>
      _SkillRoutineSettingListState();
}

class _SkillRoutineSettingListState extends State<SkillRoutineSettingListPage> {
  List<Skill> skills;
  @override
  Widget build(BuildContext context) {
    RoutineSettingBloc routineBloc =
        BlocProvider.of<RoutineSettingBloc>(context);
    final SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
    skills = skillBloc.getSkills();
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              })),
      body: new DragAndDropList<Skill>(
        skills,
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createTaskSkillWidget(context, item),
              onTap: () async {
                if(item.selected) {
                  routineBloc.getRoutineTask().skills.removeWhere((s) => s.id == item.id);
                }else {
                  routineBloc.getRoutineTask().skills.add(item);
                }
                await routineBloc.setRoutineTaskSettingSkill(
                    new RoutineTaskSettingSkill(
                        routineTaskSettingId: routineBloc.getRoutineTask().id,
                        skillId: item.id));
                await skillBloc.setAllSkillsByRoutineTaskSetting(
                    routineBloc.getRoutineTask().id);
                setState(() {
                  skills = skillBloc.getSkills();
                });
              },
              onDoubleTap: () async {
                skillBloc.setSkill(item);
                skillBloc.getSkills().removeWhere((t) => t == item);
                navigateToSkillPage(context);
              },
            ),
          );
        },
        onDragFinish: (before, after) async {
          await skillBloc.changePriorityOfSkill(before, after);
          await skillBloc.setSkills();
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
    );
  }
}

Future navigateToSkillPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SkillPage()));
}
