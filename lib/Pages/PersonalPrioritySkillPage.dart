import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Pages/ExplainProjectPage.dart';
import 'package:peaky_blinders/widgets/createPersonalProblemWidget.dart';
import 'package:peaky_blinders/widgets/createPersonalSkillWidget.dart';

class PersonalPrioritySkillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonalPrioritySkillPageState();
}

class _PersonalPrioritySkillPageState extends State<PersonalPrioritySkillPage> {
  bool init = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.grey[500],
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: new AssetImage("assets/introduction2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100.0),
              child: Text(
                "What skill has the 'highest' priority of problem: " +
                    personalBloc.getCurrentPersonalProblem().name +
                    "?",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 150.0),
              child: new DragAndDropList<Skill>(
                personalBloc.getCurrentPersonalProblem().skills,
                itemBuilder: (BuildContext context, item) {
                  return new SizedBox(
                    child: InkWell(
                      child: createPersonalSkillWidget(context, item),
                    ),
                  );
                },
                onDragFinish: (before, after) {
                  Skill skill = personalBloc.getCurrentPersonalProblem().skills[before];
                  personalBloc.getCurrentPersonalProblem().skills.removeAt(before);
                  personalBloc.getCurrentPersonalProblem().skills.insert(after, skill);
                },
                canBeDraggedTo: (one, two) => true,
                dragElevation: 8.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: MediaQuery.of(context).size.width * 0.05),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.1,
                child: RaisedButton(
                    color: Color.fromRGBO(8, 68, 22, 1.0),
                    child: const Text(
                      "Continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    elevation: 4.0,
                    splashColor: Colors.grey,
                    onPressed: () async {
                      if (personalBloc.getProblemCounter() != 2) {
                        personalBloc.nextProblem();
                        await navigateToPrioritySkillPage(context);
                      } else {
                        await navigateToExplainProjectPage(context);
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToPrioritySkillPage(context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PersonalPrioritySkillPage()));
  }

  Future navigateToExplainProjectPage(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExplainProjectPage()));
  }
}
