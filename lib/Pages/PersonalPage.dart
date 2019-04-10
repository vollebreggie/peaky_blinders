import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:peaky_blinders/Pages/chart.dart';
import 'package:validate/validate.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PersonalPageState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class _PersonalPageState extends State<PersonalPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }

    return null;
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    final List<charts.Series> seriesList = [];
    final bool animate = true;
    final Size screenSize = MediaQuery.of(context).size;

    List<charts.Series<LinearSales, int>> _createSampleData() {
      final data = [
        new LinearSales(0, 5),
        new LinearSales(1, 25),
        new LinearSales(2, 100),
        new LinearSales(3, 75),
      ];

      return [
        new charts.Series<LinearSales, int>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }

    return new Scaffold(
        // resizeToAvoidBottomPadding: true,
        body: new Container(
      color: Color.fromRGBO(60, 65, 74, 1),
      child: new Container(
        padding: const EdgeInsets.all(5.0),
        // color: Colors.white,
        child: new Container(
          child: new Center(
            child: new Column(children: [
              new Padding(padding: EdgeInsets.only(top: 5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/splashscreen.png",
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(5.0)),
                  new Flexible(
                    child: new Theme(
                      data: new ThemeData(
                          primaryColor: Colors.white70,
                          accentColor: Colors.white70,
                          hintColor: Colors.white30),
                      child: new TextFormField(
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Mike Vollebregt',
                            //filled: true,
                            suffixIcon: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  debugPrint('222');
                                })),
                        style: new TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.only(top: 15.0)),
              Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                color: Color.fromRGBO(59, 66, 84, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      //leading: Icon(Icons.album),
                      title: Text('Task Completed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                          textAlign: TextAlign.center),
                      subtitle: Text('40',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 60),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              new Container(
                  color: Colors.transparent,
                  margin: new EdgeInsets.only(top: 5.0, left: 5.0, bottom: 5),
                  child: new StackedAreaLineChart.withSampleData()),
            ]),
          ),
        ),
      ),
    ));
  }
}
