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

class ProblemSelectionCreateListPage extends StatefulWidget {
  @override
  _ProblemSelectionCreateListState createState() =>
      _ProblemSelectionCreateListState();
}

class _ProblemSelectionCreateListState
    extends State<ProblemSelectionCreateListPage> {
  
  @override
  Widget build(BuildContext context) {
    final ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    
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
        projectBloc.problems,
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createProjectProbemWidget(context, item),
              onTap: () {
                projectBloc.setProjectCreateProblem(item);

                setState(() {
                  projectBloc.setAllProblemsByCreateProject(item);
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
