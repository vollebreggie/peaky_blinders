import 'package:flutter/material.dart';
import 'package:peaky_blinders/Pages/mastersPage.dart';

class IntroductionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.grey[500],
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: new AssetImage("assets/introduction2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(padding: EdgeInsets.only(top: 100)),
            Text("Introduction",
                style: TextStyle(color: Colors.white, fontSize: 40)),
            Container(padding: EdgeInsets.only(top: 100)),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Configuring your plans, personality and ambitions will take about an hour. Be brief in your answers. Think and choose carefully. This will be your future.",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(padding: EdgeInsets.only(top: 100)),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 5.0, top: 25, right: 5),
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Card(
                  elevation: 8,
                  color: Colors.transparent,
                  margin: EdgeInsets.zero,
                  child: Container(
                    //padding: EdgeInsets.only(left: 90.0),
                    child: Center(
                      child: Text(
                        "Start apprenticeship",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    height: 80,
                    //color: Colors.transparent,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(8, 68, 22, 1.0),
                      borderRadius: new BorderRadius.only(
                          topRight: const Radius.circular(10.0),
                          bottomRight: const Radius.circular(10.0),
                          topLeft: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0)),
                      //color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              onTap: () async => navigateToMastersPage(context),
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToMastersPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MastersPage()));
  }
}
