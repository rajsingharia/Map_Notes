import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map/initial/WelcomeScreen.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  String _email = "";
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _email = user.email;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("Email :" + _email),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text("LOG OUT"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) {
                      return WelcomeScreen();
                    })).catchError((e) {
                      print(e);
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
