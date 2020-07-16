import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      title: "Maps",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Maps",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Maps();
              }));
            }),
      ),
    );
  }
}
