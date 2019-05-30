import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:validate/validate.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginPageState extends State<LoginPage> {
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

  void submit() {
    // First validate form.
    // if (this._formKey.currentState.validate()) {
    //   _formKey.currentState.save(); // Save our form now.
    // }
  }

  // Future<User> fetchPost() async {
  //   final response =
  //       await http.get('https://jsonplaceholder.typicode.com/posts/1');

  //   if (response.statusCode == 200) {
  //     // If server returns an OK response, parse the JSON
  //     return User.fromJson(json.decode(response.body));
  //   } else {
  //     // If that response was not OK, throw an error.
  //     throw Exception('Failed to load post');
  //   }
  // }

  // Future<http.Response> fetchPost2() {
  //   return http.get(
  //     'https://jsonplaceholder.typicode.com/posts/1',
  //     // Send authorization headers to your backend
  //     headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        // resizeToAvoidBottomPadding: true,
        body: new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/splashscreen.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Container(
        padding: const EdgeInsets.all(30.0),
        // color: Colors.white,
        child: new Container(
          child: new Center(
            child: new Column(children: [
              new Padding(padding: EdgeInsets.only(top: 125.0)),
              new TextFormField(
                cursorColor: Colors.white,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: "Email",
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
                    return "Email cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style:
                    new TextStyle(fontFamily: "Poppins", color: Colors.white),
              ),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new TextFormField(
                cursorColor: Colors.white,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: "Password",
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
                    return "Email cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style:
                    new TextStyle(fontFamily: "Poppins", color: Colors.white),
              ),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new SizedBox(
                width: 300,
                height: 50.0,
                child: new OutlineButton(
                  splashColor: Colors.grey,
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0)),
                  child: Text("Login",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          color: Colors.white)),
                  onPressed: () async {
                    User rnd = new User(firstName: "henk", lastName: "detank", id: 0);
                        
                   // await DBProvider.db.newUser(rnd);
                    setState(() {});
                  },
                  borderSide: BorderSide(
                    color: Colors.white, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
