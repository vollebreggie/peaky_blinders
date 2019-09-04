import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/SkillBloc.dart';
import 'package:peaky_blinders/Models/Skill.dart';

Widget createSkillsStatistics(context, List<Skill> skills) {
  SkillBloc skillBloc = BlocProvider.of<SkillBloc>(context);
  return Container(
    padding: EdgeInsets.all(25.0),
    margin: EdgeInsets.only(
      left: 5.0,
      top: 25,
      right: 5,
    ),
    height: MediaQuery.of(context).size.height * 0.4,
    width: MediaQuery.of(context).size.width,
    decoration: new BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey[900],
          blurRadius: 5.0, // has the effect of softening the shadow
          //spreadRadius: 5.0, // has the effect of extending the shadow
          offset: Offset(
            2.0, // horizontal, move right 10
            2.0, // vertical, move down 10
          ),
        ),
      ],
      color: Colors.grey[900],
      borderRadius: new BorderRadius.only(
          topRight: const Radius.circular(10.0),
          bottomRight: const Radius.circular(10.0),
          topLeft: const Radius.circular(20.0),
          bottomLeft: const Radius.circular(20.0)),
      //color: Colors.transparent,
    ),
    child: skillBloc.createSkillWebGraph(skills),
  );
}
