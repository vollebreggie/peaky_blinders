import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Pages/IntroProblemPage.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

class MasterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  final firstReasonController = TextEditingController();
  final secondReasonController = TextEditingController();
  final thirdReasonController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstReasonController.dispose();
    secondReasonController.dispose();
    thirdReasonController.dispose();
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
                "Why do you admire " +
                    personalBloc
                        .capitalize(personalBloc.getCurrentMaster().name) +
                    "?",
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
                          controller: firstReasonController,
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
                          controller: secondReasonController,
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
                          controller: thirdReasonController,
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
                    await navigateToProblemPage(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToProblemPage(context) async {
    PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
    personalBloc
        .getCurrentMaster()
        .reasons
        .add(personalBloc.createReason(firstReasonController.text));
    personalBloc
        .getCurrentMaster()
        .reasons
        .add(personalBloc.createReason(secondReasonController.text));
    personalBloc
        .getCurrentMaster()
        .reasons
        .add(personalBloc.createReason(thirdReasonController.text));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => IntroProblemPage()));
  }
}
