import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_map/initial/signUp.dart';
import 'package:lottie/lottie.dart';
import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Map Notes",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),

            //Lottie Animation
            Hero(
                tag: "loading",
                child: Lottie.asset('assets/anim/map_anim.json')),

            RaisedButton(
              highlightElevation: 0.0,
              splashColor: Color.fromRGBO(148, 0, 211, 1),
              elevation: 0.0,
              color: Color.fromRGBO(128, 0, 128, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return Login();
                }));
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              highlightElevation: 0.0,
              splashColor: Color.fromRGBO(148, 0, 211, 1),
              elevation: 0.0,
              color: Color.fromRGBO(128, 0, 128, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return SignUp();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
