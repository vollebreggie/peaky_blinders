import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PersonalBloc.dart';
import 'package:peaky_blinders/Models/Skill.dart';
import 'package:peaky_blinders/widgets/TrapeziumClipper.dart';

Widget createSkillWidget(context, int index, Skill skill, bool focus) {
  final controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  if (focus) {
    FocusScope.of(context).requestFocus(focusNode);
  }
  _settitleValue() {
    skill.title = controller.text;
  }

  controller.text = skill.title;
  controller.addListener(_settitleValue);

  return InkWell(
      child: Stack(
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
                    focusNode: focusNode,
                    controller: controller,
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
          Stack(
            children: <Widget>[
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
                                child: Text(index.toString(),
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
        ],
      ),
      onDoubleTap: () {
        PersonalBloc personalBloc = BlocProvider.of<PersonalBloc>(context);
        personalBloc.getCurrentProblem().skills.remove(skill);

        personalBloc.getSkills();
      },
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      });
}
