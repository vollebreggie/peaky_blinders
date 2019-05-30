import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Bloc/ProjectBloc.dart';
import 'package:peaky_blinders/Models/User.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserListPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(60, 65, 74, 1),
      body: Stack(
        children: <Widget>[
          Container(
            // Add box decoration
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.black38,
                  Colors.black38,
                  Colors.black45,
                  Color.fromRGBO(0, 0, 0, 0.6),
                ],
              ),
            ),
            child: Center(
              child: StreamBuilder<List<User>>(
                  stream: projectBloc.outUnselectedUser,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> snapshot) {
                    projectBloc.getUnselectedUsers();

                    return Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return makeCard(snapshot.data[index], context);
                        },
                      ),
                    );
                  }),
            ),
          ),
          new Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent, //No more green
              elevation: 0.0, //Shadow gone
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromRGBO(12, 62, 18, 0.8),
      //   child: const Icon(Icons.save),
      //   onPressed: () {
      //     projectBloc.updateNewUsersToProject();
      //     Navigator.pop(context);
      //   },
      // ),
    );
  }

  ListTile makeListTile(User user, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        leading: Container(
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
        ),
        subtitle: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.only(right: 12.0, top: 0),
          child: Text(
            user.firstName,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Icon(user.selected ? Icons.remove : Icons.group_add,
            color: Colors.white70, size: 30.0),
        onTap: () {
          final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
          projectBloc.updateUser(user);
          projectBloc.updateNewUsersToProject();
        },
      );

  Card makeCard(User user, BuildContext context) => Card(
        elevation: 2.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
            //side: BorderSide(width: 0.1, color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        color: Colors.transparent,
        child: Container(
          height: 75,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: makeListTile(user, context),
                ),
              ),
            ],
          ),
        ),
      );

  String getImageFromServer(context, image) {
    final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);
    return projectBloc.getImageFromServer(image);
  }
}
