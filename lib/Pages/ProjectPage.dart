import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/ProjectTaskBloc.dart';
import 'package:peaky_blinders/Database/Repository.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:peaky_blinders/Models/ProjectTask.dart';
import 'package:peaky_blinders/Pages/CreateTaskPage.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final ProjectTaskBloc taskBloc = BlocProvider.of<ProjectTaskBloc>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: new Column(
          children: [
            new TextFormField(
              cursorColor: Colors.white,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.white)),
                labelText: "Project Title",
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Title cannot be empty";
                } else {
                  return null;
                }
              },
              //keyboardType: TextInputType.emailAddress,
              style: new TextStyle(fontFamily: "Poppins", color: Colors.white),
            ),
            new TextFormField(
              cursorColor: Colors.white,
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.white)),
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
              ),
              style: new TextStyle(fontFamily: "Poppins", color: Colors.white),
            ),
            new CarouselSlider(
              height: 200.0,
              items: [
                "ironman.png",
                "splashscreen.jpg",
                "profile.jpg",
                "background.png",
                "dashboard.jpg"
              ].map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      image: new DecorationImage(
                        image: new AssetImage("assets/$image"),
                        fit: BoxFit.fill,
                      ),
                    ));
                  },
                );
              }).toList(),
            ),
            StreamBuilder<List<ProjectTask>>(
                stream: taskBloc.outProjectTask,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProjectTask>> snapshot) {
                  taskBloc.fetchProjectTask.add(null);
                  return Container(
                    // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return makeCard(snapshot.data[index]);
                      },
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          saveProject(context, projectBloc);
        },
      ),
    );
  }

  void saveProject(BuildContext context, ProjectBloc bloc) {
    Project project = new Project(id: 1, title: "doei", description: "hallo");
    Repository.get().updateProject(project);
    bloc.fetchProject.add(null);
    navigateBack(context);
  }

  void makeNewTask(Project project, BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateTaskPage(project)));
  }

  ListTile makeListTile(ProjectTask projectTask) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Colors.white),
        ),
        title: Text(
          projectTask.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: 0,
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(projectTask.title,
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => DetailTaskPage(task: task)));
        },
      );

  Card makeCard(ProjectTask projectTask) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(projectTask),
        ),
      );

  Future navigateBack(context) async {
    Navigator.pop(context, true);
  }
}
