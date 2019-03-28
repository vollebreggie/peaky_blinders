
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/IncrementBloc.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';

class NewProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          SaveProject(context, bloc);
        },
      ),
    );
  }

void SaveProject(BuildContext context, IncrementBloc bloc) {

    Project project = new Project(
        id: 1,
        title: "doei",
        description: "hallo");

    //Repository.get().test();
    Repository.get().updateProject(project);
    bloc.fetchProject.add(null);
    navigateBack(context);
  }

  Future navigateBack(context) async {
    Navigator.pop(context, true);
  }
}