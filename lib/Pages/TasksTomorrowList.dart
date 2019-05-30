import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Models/RoutineTask.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/widgets/TomorrowTaskWidget.dart';

class TasksTomorrowListPage extends StatefulWidget {
  
  @override
  _TasksTomorrowListState createState() => _TasksTomorrowListState();
}

class _TasksTomorrowListState extends State<TasksTomorrowListPage> {
   List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    tasks = taskBloc.getTasksForTomorrow();
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
      body: new DragAndDropList<Task>(
        tasks,
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
              child: InkWell(
                  child: createTomorrowTaskWidget(context, item),
                  onTap: () async {
                    if (item.runtimeType == ProjectTask) {
                      final TaskBloc taskBloc =
                          BlocProvider.of<TaskBloc>(context);
                      await taskBloc.setProjectTaskForTomorrow(item);
                      await taskBloc.setTasksForTomorrow();
                      setState(() {
                       tasks = taskBloc.getTasksForTomorrow(); 
                      });
                    }
                  }));
        },
        onDragFinish: (before, after) async {
          await taskBloc.changePriorityOfTasksTomorrow(before, after);
          await taskBloc.setTasksForToday();
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
    );
  }
}
