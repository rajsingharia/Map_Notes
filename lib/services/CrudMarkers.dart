import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String currUser;

class CrudMarkers {
  Future<void> createMarker(mapData, context) async {
    Firestore.instance
        .collection(currUser + "_parking")
        .add(mapData)
        .then((value) {
      SnackBar snackbar = new SnackBar(content: Text("Marker Added"));
      Scaffold.of(context).showSnackBar(snackbar);
    }).catchError((e) {
      print("Setting data ERROR-->>" + e.toString());
    });
  }

  Future<void> deleteMarker(String id) async {
    Firestore.instance
        .collection(currUser + "_parking")
        .document(id)
        .delete()
        .then((value) {})
        .catchError((e) {
      print(e);
    });
  }
}
