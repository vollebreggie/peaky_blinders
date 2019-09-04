import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Models/Task.dart';
import 'package:peaky_blinders/Pages/SkillCreatePage.dart';
import 'package:peaky_blinders/Pages/SkillPage.dart';
import 'package:peaky_blinders/widgets/createSkillWidget.dart';

class SkillListPage extends StatefulWidget {
  @override
  _SkillListState createState() => _SkillListState();
}

class _SkillListState extends State<SkillListPage> {
  @override
  Widget build(BuildContext context) {
    final SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                    Navigator.pop(context, false),
                  })),
      backgroundColor: Color.fromRGBO(1, 1, 1, 0.83),
      body: new DragAndDropList<Skill>(
        skillBloc.getSkills(),
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createSkillWidget(context, item),
              onTap: () async {
                skillBloc.setSkill(item);
                navigateToSkillPage(context);
              },
              onDoubleTap: () async {
                _showDeleteDialog(context, item);
              },
            ),
          );
        },
        onDragFinish: (before, after) async {
          await skillBloc.changePriorityOfSkill(before, after);
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
        child: const Icon(Icons.add),
        onPressed: () async {
          skillBloc.setSkill(new Skill(id: 0, points: 0, title: "", userId: 0, place: 0, description: "", imagePathServer: null));
          await navigateToCreateSKillPage(context);
        },
      ),
    );
  }

  Future navigateToCreateSKillPage(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SkillCreatePage()),
    );
  }

  Future navigateToSkillPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SkillPage()));
  }

  void _showDeleteDialog(context, Skill skill) {
    SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Skill?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  await skillBloc.removeSkill(skill);
                  setState(() {
                    
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
}
