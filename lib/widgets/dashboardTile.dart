import 'package:flutter/material.dart';

Widget createDashboardTileRightBottom(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(left: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}

Widget createDashboardTileRight(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(left: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      //margin: EdgeInsets.only(left: 10.00, top: 15),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
            top: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}

Widget createDashboardTileLeftBottom(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(right: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      //margin: EdgeInsets.only(right: 10.00, top: 15),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}

Widget createDashboardTileRightTop(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(left: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      //margin: EdgeInsets.only(left: 10.00, top: 15),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
            right: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}

Widget createDashboardTileLeftTop(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(right: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      //margin: EdgeInsets.only(right: 10.00, top: 15),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
            top: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}

Widget createDashboardTileLeft(context, text) {
  return Container(
    // Add box decoration
    margin: EdgeInsets.only(right: 10.00, top: 15),
    height: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
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
    ),
    // Box decoration takes a gradient
    child: Container(
      //margin: EdgeInsets.only(right: 10.00, top: 15),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: new BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10)),
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 10.0,
            ),
            top: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(8, 68, 22, 1.0),
              width: 5.0,
            ),
          ),
        ),
        //padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 25),
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        // color: Colors.blue,
        child: Center(
          child: new Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),
  );
}
