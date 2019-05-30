import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Pages/TVUserListPage.dart';
import 'package:peaky_blinders/Pages/UserListPage.dart';
import 'package:peaky_blinders/widgets/TrapeziumLeftClipper.dart';

Widget createSelectedUsers(context, users) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 10,
          right: 5,
        ),
        height: 70,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 3),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                margin: new EdgeInsets.only(
                    top: 5.0, left: 15.0, bottom: 5, right: 5),
                child: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Color.fromRGBO(60, 65, 74, 1),
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: users != null
                          ? getImageOfUser(context, users)
                          : new Container(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 70,
          //color: Colors.transparent,
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[900],
                blurRadius: 5.0, // has the effect of softening the shadow
                //spreadRadius: 5.0, // has the effect of extending the shadow
                offset: Offset(
                  4.0, // horizontal, move right 10
                  4.0, // vertical, move down 10
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
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 5),
        child: Align(
          alignment: Alignment.topRight,
          child: ClipPath(
            clipper: TrapeziumLeftClipper(),
            child: Container(
              decoration: new BoxDecoration(
                  color: Color.fromRGBO(8, 68, 22, 1.0),
                  borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0))),
              //color: Color.fromRGBO(6, 32, 12, 1.0),
              //padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.25,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          // maxHeight: 70,
                          maxWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Center(
                          child:
                              Icon(Icons.group, size: 40, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

String getImageFromServer(context, image) {
  final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
  return projectBloc.getImageFromServer(image);
}

List<Widget> getImageOfUser(context, users) {
  List<Widget> widgets = [];

  widgets.addAll(users
      .map<Widget>((user) => Container(
            padding: EdgeInsets.only(right: 5),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: new CachedNetworkImage(
                fit: BoxFit.fill,
                height: 40,
                width: 40,
                imageUrl: getImageFromServer(context, user.image),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ))
      .toList());

  
    widgets.add(
      new IconButton(
        color: Colors.white70,
        icon: new Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: ()  {
          ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
        navigateToUserListPage(context);
        projectBloc.syncUnselectedUsers();
      }
    ),
  );

  return widgets;
}

Future navigateToUserListPage(context) async {
  //tvBloc.syncUnselectedUsers();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => UserListPage()));
}