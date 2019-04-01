
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';

class NewProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc bloc = BlocProvider.of<ProjectBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          saveProject(context, bloc);
        },
      ),
    );
  }

void saveProject(BuildContext context, ProjectBloc bloc) {

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