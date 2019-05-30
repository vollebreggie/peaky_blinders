import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/PageBLoc.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Bloc/RoutineSettingBloc.dart';
import 'package:peaky_blinders/Bloc/TaskBloc.dart';
import 'package:peaky_blinders/Bloc/UserBLoc.dart';
import 'package:peaky_blinders/Pages/PersonalPage.dart';
import 'package:peaky_blinders/Pages/ProjectListPage.dart';
import 'package:peaky_blinders/Pages/RoutineListPage.dart';
import 'package:peaky_blinders/Pages/SynopsPage.dart';
import 'package:peaky_blinders/Pages/TaskListPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // final _controller = new PageController(
  //   initialPage: 0,
  //   keepPage: true,
  // );
  PageBloc pageBloc;
  // int bottomSelectedIndex = 0;
  final _kArrowColor = Color.fromRGBO(51, 3, 0, 1.0);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(), child: new SynopsPage()),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(), child: new TaskListPage()),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new ProjectListPage()),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new RoutineListPage(),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new PersonalPage(),
    ),
  ];

  void pageChanged(int index) {
    setState(() {
      pageBloc.page = index;
    });
  }

  void navigateToPage(int index) {
    setState(() {
      pageBloc.page = index;
      pageBloc.controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void initData(context) async {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    final RoutineSettingBloc routineTaskBloc = BlocProvider.of<RoutineSettingBloc>(context);

    //login user so that data can be retrieved
    userBloc.login("mikevol@live.nl", "testing");

    //retrieve data from server
    await projectBloc.syncEverything();
    await routineTaskBloc.syncRoutineSettings();

    //set data for pages
    await routineTaskBloc.setRoutineSettings();
    await taskBloc.setTasksForToday();
    await projectBloc.setProjectCount();
    await taskBloc.setNextTask();
  }

  @override
  Widget build(BuildContext context) {
    pageBloc = BlocProvider.of<PageBloc>(context);
    initData(context);
    return new Scaffold(
      // backgroundColor: Colors.red,//.fromRGBO(51, 3, 0, 0.9),
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            new PageView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              controller: pageBloc.controller,
              onPageChanged: (index) {
                pageChanged(index);
              },
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    child: _pages[index % _pages.length],
                    onHorizontalDragEnd: (dragEndDetails) {
                      if (dragEndDetails.primaryVelocity < 0 &&
                          pageBloc.page == 4) {
                        pageBloc.page = 0;
                        navigateToPage(pageBloc.page);
                      } else if (dragEndDetails.primaryVelocity > 0 &&
                          pageBloc.page == 0) {
                        pageBloc.page = 4;
                        navigateToPage(pageBloc.page);
                      } else if (dragEndDetails.primaryVelocity > 0 &&
                          pageBloc.page != 0) {
                        pageBloc.page--;
                        navigateToPage(pageBloc.page);
                      } else if (dragEndDetails.primaryVelocity < 0 &&
                          pageBloc.page != 4) {
                        pageBloc.page++;
                        navigateToPage(pageBloc.page);
                      }
                    });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`s
            canvasColor: Color.fromRGBO(8, 68, 22, 0.98),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color: Colors
                        .white))), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          onTap: (index) {
            navigateToPage(index);
          },
          currentIndex: pageBloc.page,
          //fixedColor: Colors.transparent,
          type: BottomNavigationBarType.shifting,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.dashboard),
              ),
              title: Text(
                'Dashboard',
                style: new TextStyle(color: Colors.white),
              ),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.dashboard),
              ),
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.0,
                    colors: <Color>[Colors.white, Colors.white30],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.view_headline),
              ),
              title: Text(
                'Tasks Today',
                style: new TextStyle(color: Colors.white),
              ),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.0,
                    colors: <Color>[Colors.white, Colors.white30],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.view_headline),
              ),
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.0,
                    colors: <Color>[Colors.white, Colors.white70],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.view_agenda),
              ),
              title: Text(
                'Projects',
                style: new TextStyle(color: Colors.white),
              ),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.0,
                    colors: <Color>[Colors.white, Colors.white70],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.view_agenda),
              ),
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.repeat),
              ),
              title: Text(
                'Routine',
                style: new TextStyle(color: Colors.white),
              ),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.repeat),
              ),
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.account_circle),
              ),
              title: Text(
                'Personal',
                style: new TextStyle(color: Colors.white),
              ),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: <Color>[Colors.white70, Colors.white],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(Icons.account_circle),
              ),
            ),
          ],
          // new BottomNavigationBarItem(
          //   activeIcon: new Icon(Icons.access_alarm),
          //   icon: new Icon(Icons.access_alarm),
          //   title: new Text("hello"),
          // ),
        ),
      ),
    );
  }
}
