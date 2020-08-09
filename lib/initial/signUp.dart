import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map/initial/WelcomeScreen.dart';

import '../maps.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => WelcomeScreen()));
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              highlightElevation: 0.0,
              splashColor: Color.fromRGBO(148, 0, 211, 1),
              elevation: 0.0,
              color: Color.fromRGBO(128, 0, 128, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              onPressed: () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _email, password: _password)
                    .then((result) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (builder) {
                    return Maps();
                  }));
                }).catchError((e) {
                  print("ERROR ---> " + e.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
