import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Pages/CreateRoutinePage.dart';
import 'package:peaky_blinders/Pages/RoutinePage.dart';
import 'package:peaky_blinders/widgets/createRoutineTaskWidget.dart';

class RoutineListPage extends StatefulWidget {
  @override
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineListPage> {
  @override
  Widget build(BuildContext context) {
    RoutineSettingBloc settingTaskBloc = BlocProvider.of<RoutineSettingBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: Center(
        child: new DragAndDropList<RoutineTaskSetting>(
          settingTaskBloc.getRoutineTaskSettings(),
          itemBuilder: (BuildContext context, item) {
            return new SizedBox(
              child: InkWell(
                child: createRoutineTask(context, item),
                onTap: () async {
                  settingTaskBloc.setRoutineTask(item);
                  settingTaskBloc.getRoutineTaskSettings().removeWhere((t) => t == item);
                  navigateToRoutineTaskPage(context);
                },
              ),
            );
          },
          onDragFinish: (before, after) {
            settingTaskBloc.changePriorityOfRoutineTask(before, after);
          },
          canBeDraggedTo: (one, two) => true,
          dragElevation: 8.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
        heroTag: null,
        child: const Icon(Icons.add),
        onPressed: () {
          navigateToCreateRoutineTaskPage(context);
        },
      ),
    );
  }

  Future navigateToCreateRoutineTaskPage(context) async {
    RoutineSettingBloc taskBloc = BlocProvider.of<RoutineSettingBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    taskBloc.setRoutineTask(new RoutineTaskSetting(
        id: 0,
        title: "New RoutineTaskSetting",
        points: 1,
        place: taskBloc.getRoutineTaskSettings().length,
        userId: userBloc.getUser().id,
        user: null,
        monday: 0,
        tuesday: 0,
        wednesday: 0,
        thursday: 0,
        friday: 0,
        saturday: 0,
        sunday: 0));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRoutinePage()),
    );
  }

  Future navigateToRoutineTaskPage(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoutinePage()),
    );
  }
}
