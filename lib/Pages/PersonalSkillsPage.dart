import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/Pages/PersonalPriorityProblemPage.dart';
import 'package:peaky_blinders/widgets/SkillWidget.dart';
import 'package:peaky_blinders/widgets/personalSkillWidget.dart';

class PersonalSkillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonalSkillPageState();
}

class _PersonalSkillPageState extends State<PersonalSkillPage> {
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
                    personalBloc.getCurrentPersonalProblem().name +
                    "?",
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
                    personalBloc.getPersonalSkills();
                  }

                  return Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        int counter = index + 1;
                        return createPersonalSkillWidget(
                            context, counter, snapshot.data[index]);
                      },
                    ),
                  );
                }),
            Container(
              padding: EdgeInsets.only(top: 20.0),
            ),
            personalBloc.getCurrentPersonalProblem().skills.length != 5
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
                            personalBloc.getCurrentPersonalProblem().skills.add(
                                personalBloc.createSkillWithId(
                                    "",
                                    personalBloc
                                        .getCurrentPersonalProblem()
                                        .skills
                                        .length + 1));
                          });
                          personalBloc.getPersonalSkills();
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
                      personalBloc.getPersonalSkills();
                    } else {
                      await navigateToPriorityProblemPage(context);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToPriorityProblemPage(context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PersonalPriorityProblemPage()));
  }
}
