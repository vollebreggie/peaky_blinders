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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height *
              0.4), // here the desired height
          child: AppBar(
            flexibleSpace: Stack(children: <Widget>[
              new Image.asset(
                "assets/splashscreen.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
              ),
              new Align(
                alignment: FractionalOffset.bottomLeft,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                      initialValue: "someText",
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                      ),
                      style:
                          new TextStyle(fontSize: 25.0, color: Colors.white)),
                ),
              ),
            ]),
            backgroundColor: Colors.transparent,
          )),
      body: Center(
        child: SingleChildScrollView(
          child: new Column(
            children: [
              new Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: new Column(children: [
                    // new CarouselSlider(
                    //   aspectRatio: 16 / 9,
                    //   viewportFraction: 0.8,
                    //   initialPage: 0,
                    //   enableInfiniteScroll: true,
                    //   reverse: false,
                    //   autoPlay: true,
                    //   autoPlayInterval: Duration(seconds: 3),
                    //   autoPlayAnimationDuration: Duration(milliseconds: 800),
                    //   pauseAutoPlayOnTouch: Duration(seconds: 10),
                    //   enlargeCenterPage: true,
                    //   scrollDirection: Axis.horizontal,
                    //   height: 200.0,
                    //   items: [
                    //     "splashscreen.jpg",
                    //     "profile.jpg",
                    //     "map.png",
                    //     "dashboard.jpg"
                    //   ].map((image) {
                    //     return Builder(
                    //       builder: (BuildContext context) {
                    //         return Container(
                    //             width: MediaQuery.of(context).size.width,
                    //             margin: EdgeInsets.symmetric(horizontal: 5.0),
                    //             decoration: new BoxDecoration(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(25.0)),
                    //               image: new DecorationImage(
                    //                 image: new AssetImage("assets/$image"),
                    //                 fit: BoxFit.fill,
                    //               ),
                    //             ));
                    //       },
                    //     );
                    //   }).toList(),
                    // ),
                    new Card(
                      //elevation: 8.0,
                      // margin: new EdgeInsets.symmetric(
                      //     horizontal: 5.0, vertical: 6.0),
                      color: Colors.grey,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 0),

                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        //padding: EdgeInsets.all(10.0),
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
                                  textAlign: TextAlign.center,
                                  maxLines: 100,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Description of the project',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
              StreamBuilder<List<ProjectTask>>(
                  stream: taskBloc.outProjectTask,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProjectTask>> snapshot) {
                    taskBloc.fetchProjectTask.add(null);
                    return Container(
                      color: Color.fromRGBO(58, 66, 86, 1.0),
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
