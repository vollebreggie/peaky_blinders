import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
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
    RoutineSettingBloc settingTaskBloc =
        BlocProvider.of<RoutineSettingBloc>(context);
   SkillBloc skillBloc =
        BlocProvider.of<SkillBloc>(context);

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
                  item.skills = await skillBloc.getAllSkillsForRoutineTaskSettingById(item.id);
                  settingTaskBloc.setRoutineTask(item);
                  settingTaskBloc
                      .getRoutineTaskSettings()
                      .removeWhere((t) => t == item);

                  settingTaskBloc.skills = [];
                  settingTaskBloc.selectedSkills = [];
                  await navigateToRoutineTaskPage(context);
                },
                onDoubleTap: () async {
                  _showDialog(context, item);
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
    taskBloc.selectedSkills = [];
    taskBloc.skills = [];
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
        sunday: 0,
        skills: []));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRoutinePage()),
    );
  }

  void _showDialog(context, RoutineTaskSetting routineTaskSetting) {
    RoutineSettingBloc settingTaskBloc =
        BlocProvider.of<RoutineSettingBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Routine?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  await settingTaskBloc
                      .deleteRoutineSettingsTask(routineTaskSetting);
                  setState(() {
                    //settingTaskBloc.getRoutineTaskSettings();
                  });
                  Navigator.of(context).pop();
                },
                splashColor: Colors.grey,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Container(
                  //margin: const EdgeInsets.all(10.0),
                  child: Text('Delete'),
                ),
              ),
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future navigateToRoutineTaskPage(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoutinePage()),
    );
  }
}
