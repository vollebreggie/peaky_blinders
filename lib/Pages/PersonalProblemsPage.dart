import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Pages/PersonalSkillsPage.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

class PersonalProblemsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonalProblemPageState();
}

class _PersonalProblemPageState extends State<PersonalProblemsPage> {
  final firstProblemController = TextEditingController();
  final secondProblemController = TextEditingController();
  final thirdProblemController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstProblemController.dispose();
    secondProblemController.dispose();
    thirdProblemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                "What are three complex problems you want to be able to solve?",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(padding: EdgeInsets.only(top: 50)),
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 5),
                  decoration: new BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                      topLeft: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.green),
                        title: TextField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          controller: firstProblemController,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
                  child: ClipPath(
                    clipper: TrapeziumClipper(),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(8, 68, 22, 1.0),
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(10.0),
                              bottomLeft: const Radius.circular(10.0))),
                      //color: Color.fromRGBO(6, 32, 12, 1.0),
                      //padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 56,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  // maxHeight: 70,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.3),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("1",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 5),
                  decoration: new BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                      topLeft: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.green),
                        title: TextField(
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          controller: secondProblemController,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
                  child: ClipPath(
                    clipper: TrapeziumClipper(),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(8, 68, 22, 1.0),
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(10.0),
                              bottomLeft: const Radius.circular(10.0))),
                      //color: Color.fromRGBO(6, 32, 12, 1.0),
                      //padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 56,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  // maxHeight: 70,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.3),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("2",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 5),
                  decoration: new BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                      topLeft: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.green),
                        title: TextField(
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          controller: thirdProblemController,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5),
                  child: ClipPath(
                    clipper: TrapeziumClipper(),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(8, 68, 22, 1.0),
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(10.0),
                              bottomLeft: const Radius.circular(10.0))),
                      //color: Color.fromRGBO(6, 32, 12, 1.0),
                      //padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 56,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  // maxHeight: 70,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.3),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("3",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
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
                    await navigateToPriorityPage(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToPriorityPage(context) async {
    PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
    personalBloc.getUser().problems = [];
    personalBloc
        .getUser()
        .problems
        .add(personalBloc.createProblemWithId(firstProblemController.text, 1));
    personalBloc
        .getUser()
        .problems
        .add(personalBloc.createProblemWithId(secondProblemController.text, 2));
    personalBloc
        .getUser()
        .problems
        .add(personalBloc.createProblemWithId(thirdProblemController.text, 3));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PersonalSkillPage()));
  }
}
