import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Pages/MasterPage.dart';
import 'package:peaky_blinders/Pages/MastersPage.dart';
import 'package:peaky_blinders/Pages/PersonalProblemsPage.dart';
import 'package:peaky_blinders/widgets/SkillWidget.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

class IntroSkillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _IntroSkillPageState();
}

class _IntroSkillPageState extends State<IntroSkillPage> {
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
        child: Column(
          children: <Widget>[
            Container(padding: EdgeInsets.only(top: 100)),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "What skills are necessary to able to solve the problem: " +
                    personalBloc.getCurrentProblem().name +
                    "?" +
                    (personalBloc.getProblemCounter() == 0 &&
                            personalBloc.getMasterCounter() == 0
                        ? " Tip: doubletap on a skill to remove it."
                        : ""),
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(padding: EdgeInsets.only(top: 50)),
            StreamBuilder<List<Skill>>(
                stream: personalBloc.outSkill,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<Skill>> snapshot) {
                  if (init) {
                    init = false;
                    personalBloc.getSkills();
                  }
                  //
                  return Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        int counter = index + 1;
                        return createSkillWidget(
                            context,
                            counter,
                            snapshot.data[index],
                            snapshot.data.length == counter ? true : false);
                      },
                    ),
                  );
                }),
            Container(
              padding: EdgeInsets.only(top: 20.0),
            ),
            personalBloc.getCurrentProblem().skills.length != 5
                ? ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: RaisedButton(
                        color: Colors.grey[900],
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 80),
                              ),
                              const Text(
                                " Skill",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 80),
                              ),
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 50,
                              ),
                            ],
                          ),
                        ),
                        elevation: 4.0,
                        splashColor: Colors.grey,
                        onPressed: () async {
                          setState(() {
                            personalBloc
                                .getCurrentProblem()
                                .skills
                                .add(personalBloc.createSkill(""));
                          });
                          personalBloc.getSkills();
                        }),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.only(top: 10.0),
            ),
            ButtonTheme(
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
                    if (personalBloc.continueWithProblem()) {
                      setState(() {
                        personalBloc.nextProblem();
                      });
                      personalBloc.getSkills();
                    } else if (personalBloc.continueWithMasters()) {
                      personalBloc.setNextMaster();
                      personalBloc.resetProblemCounter();
                      await navigateToMasterPage(context);
                    } else {
                      personalBloc.resetProblemCounter();
                      await navigateToPersonalProblemPage(context);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToPersonalProblemPage(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PersonalProblemsPage()));
  }

  Future navigateToMasterPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MasterPage()));
  }
}
