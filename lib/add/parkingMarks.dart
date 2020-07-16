import 'package:flutter/material.dart';

class ParkingMarks extends StatefulWidget {
  @override
  _ParkingMarksState createState() => _ParkingMarksState();
}

class _ParkingMarksState extends State<ParkingMarks> {
  double lat, long;
  TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking Mark"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                child: TextField(
                  controller: _description,
                  decoration: InputDecoration(hintText: "Description"),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
