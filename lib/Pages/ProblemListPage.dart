import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProblemBloc.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Pages/ProblemCreatePage.dart';
import 'package:peaky_blinders/Pages/ProblemPage.dart';
import 'package:peaky_blinders/widgets/createProblemWidget.dart';

class ProblemListPage extends StatefulWidget {
  @override
  _ProblemListState createState() => _ProblemListState();
}

class _ProblemListState extends State<ProblemListPage> {
  @override
  Widget build(BuildContext context) {
    final ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
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
      body: new DragAndDropList<Problem>(
        problemBloc.getProblems(),
        itemBuilder: (BuildContext context, item) {
          return new SizedBox(
            child: InkWell(
              child: createProblemWidget(context, item),
              onTap: () async {
                problemBloc.setProblem(item);
                navigateToProblemPage(context);
              },
              onDoubleTap: () async {
                _showDeleteDialog(context, item);
              },
            ),
          );
        },
        onDragFinish: (before, after) async {
          await problemBloc.changePriorityOfProblem(before, after);
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(47, 87, 53, 0.8),
        child: const Icon(Icons.add),
        onPressed: () async {
          problemBloc.setProblem(new Problem(id: 0, place: 0, userId:0 , points: 0, name: "", imagePath: null));
          await navigateToCreateProblemPage(context);
        },
      ),
    );
  }

  Future navigateToCreateProblemPage(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProblemCreatePage()),
    );
  }

  Future navigateToProblemPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProblemPage()));
  }

  void _showDeleteDialog(context, Problem problem) {
    ProblemBloc problemBloc = BlocProvider.of<ProblemBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Problem?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 150.0,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  await problemBloc.removeProblem(problem);
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
