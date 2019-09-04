import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/ProjectProblem.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/ProblemPage.dart';
import 'package:peaky_blinders/Pages/TaskPage.dart';
import 'package:peaky_blinders/widgets/TomorrowProjectTaskWidget.dart';
import 'package:peaky_blinders/widgets/TomorrowRoutineTaskWidget.dart';
import 'package:peaky_blinders/widgets/createProjectProblemWidget.dart';

class ProblemSelectionListPage extends StatefulWidget {
  @override
  _ProblemSelectionListState createState() => _ProblemSelectionListState();
}

class _ProblemSelectionListState extends State<ProblemSelectionListPage> {
  List<Problem> problems;
  @override
  Widget build(BuildContext context) {
    final ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    problems = problemBloc.getProblems();
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
      body: new DragAndDropList<Problem>(
        problems,
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createProjectProbemWidget(context, item),
              onTap: () async {
                await projectBloc.setProjectProblem(new ProjectProblem(
                    problemId: item.id,
                    projectId: projectBloc.getCurrentProject().id));
                await problemBloc.setAllProblemsByProject(
                    projectBloc.getCurrentProject().id);
                setState(() {
                  problems = problemBloc.getProblems();
                });
              },
              onDoubleTap: () async {
                problemBloc.setProblem(item);
                problemBloc.getProblems().removeWhere((t) => t == item);
                navigateToProblemPage(context);
              },
            ),
          );
        },
        onDragFinish: (before, after) async {
          await problemBloc.changePriorityOfProblem(before, after);
          await problemBloc.setProblems();
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
    );
  }
}

Future navigateToProblemPage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProblemPage()));
}
