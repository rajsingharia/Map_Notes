import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map/initial/WelcomeScreen.dart';
import 'package:google_map/services/CrudMarkers.dart';
import 'package:lottie/lottie.dart';
import 'maps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    isUserAlreadrLoggedIn();
  }

  int pos = 2;
  void isUserAlreadrLoggedIn() async {
    await FirebaseAuth.instance.currentUser().then((value) {
      currUser = value.uid.toString();
    });
    if (await FirebaseAuth.instance.currentUser() != null) {
      setState(() {
        pos = 1;
      });
    } else if (await FirebaseAuth.instance.currentUser() == null) {
      setState(() {
        pos = 0;
      });
    }
  }

  var screenDisplay = {WelcomeScreen(), Maps(), LoadingScreen()};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      title: "Maps",
      // home: SplashScreen(
      //   seconds: 2,
      //   backgroundColor: Colors.white,
      //   image: Image.asset('assets/anim/loading.gif'),
      //   title: Text(
      //     "Map Notes",
      //     style: TextStyle(
      //       fontSize: 40,
      //       fontWeight: FontWeight.w900,
      //     ),
      //   ),
      //   loaderColor: Colors.white,
      //   photoSize: 150,
      //   navigateAfterSeconds: screenDisplay.elementAt(pos),
      // ),
      home: screenDisplay.elementAt(pos),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Hero(
              tag: "loading", child: Lottie.asset('assets/anim/map_anim.json')),
        ),
      ),
    );
  }
}
