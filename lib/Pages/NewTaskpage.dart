import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';

class NewTaskPage extends StatefulWidget {

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTaskPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 200.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: new InkWell(
        // to dismiss the keyboard when the user tabs out of the TextField
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              //SizedBox(height: _animation.value),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                focusNode: _focusNode,
              ),
              Container(
                height: 200,
                color: Color(0xffeeeeee),
                padding: EdgeInsets.all(10.0),
                child: new ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200.0,
                  ),
                  child: new Scrollbar(
                    child: new SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: SizedBox(
                        height: 190.0,
                        child: new TextField(
                          controller: descriptionController,
                          maxLines: 100,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add your text here',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new SizedBox(
                width: 300,
                height: 50.0,
                child: new OutlineButton(
                  splashColor: Colors.grey,
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0)),
                  child: Text("Create Task",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          color: Colors.white)),
                  onPressed: () {
                    SaveProjectTask(context);
                  },
                  borderSide: BorderSide(
                    color: Colors.white, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void SaveProjectTask(BuildContext context) {
    ProjectTask task = new ProjectTask(
        id: 1,
        title: titleController.text,
        description: descriptionController.text,
        started: DateTime.now().toString(),
        completed: "null");
    //Repository.get().test();
    Repository.get().updateProjectTask(task);
    navigateBack(context);
  }

  Future navigateBack(context) async {
    Navigator.pop(context, true);
  }
}
