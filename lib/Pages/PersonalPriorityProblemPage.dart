import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Pages/PersonalPrioritySkillPage.dart';
import 'package:peaky_blinders/widgets/createPersonalProblemWidget.dart';

class PersonalPriorityProblemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      new _PersonalPriorityProblemPageState();
}

class _PersonalPriorityProblemPageState
    extends State<PersonalPriorityProblemPage> {
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
                "What problem has the 'highest' priority? Tip: Hold and drag to change the priority. The problem on top has the highest priority.",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 250.0),
              child: new DragAndDropList<Problem>(
                personalBloc.getUser().problems,
                itemBuilder: (BuildContext context, item) {
                  return new SizedBox(
                    child: InkWell(
                      child: createPersonalProblemWidget(context, item),
                    ),
                  );
                },
                onDragFinish: (before, after) {
                  Problem problem = personalBloc.getUser().problems[before];
                  personalBloc.getUser().problems.removeAt(before);
                  personalBloc.getUser().problems.insert(after, problem);
                },
                canBeDraggedTo: (one, two) => true,
                dragElevation: 8.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 280.0),
              child: Center(
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
                        personalBloc.resetProblemCounter();
                        await navigateToPrioritySkillPage(context);
                      }),
                ),
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
}
