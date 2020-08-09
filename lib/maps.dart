import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_map/other/allSaved.dart';
import 'package:google_map/services/CrudMarkers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'other/account.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

String imageUrl;
Set<Marker> _markers = HashSet<Marker>();
GoogleMapController _mapController;
BitmapDescriptor _parkingmarkerIcon, _futuremarkerIcon, _landmarkerIcon;
String _mapStyle;
String _noteAbout;

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    getLoaction();
    setMarkerIcon();
    rootBundle.loadString('assets/style/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  Widget loadMaps() {
    return StreamBuilder(
      stream: Firestore.instance.collection(currUser + "_parking").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading Map",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        _markers.clear();
        for (int index = 0; index < snapshot.data.documents.length; index++) {
          if (snapshot.data.documents[index]['label'].toString() == 'parking') {
            _markers.add(Marker(
                markerId: MarkerId(snapshot.data.documents[index].documentID),
                position: LatLng(
                    snapshot.data.documents[index]['coords'].latitude,
                    snapshot.data.documents[index]['coords'].longitude),
                icon: _parkingmarkerIcon,
                onTap: () {
                  print(snapshot.data.documents[index]['about'].toString());
                  displayDeleteWindow(
                      snapshot.data.documents[index].documentID.toString(),
                      snapshot.data.documents[index]['about'].toString(),
                      snapshot.data.documents[index]['image'].toString(),
                      context);
                  setState(() {
                    _markers.clear();
                  });
                }));
          } else if (snapshot.data.documents[index]['label'].toString() ==
              'land') {
            _markers.add(Marker(
                markerId: MarkerId(snapshot.data.documents[index].documentID),
                position: LatLng(
                    snapshot.data.documents[index]['coords'].latitude,
                    snapshot.data.documents[index]['coords'].longitude),
                icon: _landmarkerIcon,
                onTap: () {
                  print(snapshot.data.documents[index]['about'].toString());
                  displayDeleteWindow(
                      snapshot.data.documents[index].documentID.toString(),
                      snapshot.data.documents[index]['about'].toString(),
                      snapshot.data.documents[index]['image'].toString(),
                      context);
                  setState(() {
                    _markers.clear();
                  });
                }));
          } else if (snapshot.data.documents[index]['label'].toString() ==
              'future') {
            _markers.add(Marker(
                markerId: MarkerId(snapshot.data.documents[index].documentID),
                position: LatLng(
                    snapshot.data.documents[index]['coords'].latitude,
                    snapshot.data.documents[index]['coords'].longitude),
                icon: _futuremarkerIcon,
                onTap: () {
                  print(snapshot.data.documents[index]['about'].toString());
                  displayDeleteWindow(
                      snapshot.data.documents[index].documentID.toString(),
                      snapshot.data.documents[index]['about'].toString(),
                      snapshot.data.documents[index]['image'].toString(),
                      context);
                  setState(() {
                    _markers.clear();
                  });
                }));
          }
        }
        return GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
          markers: _markers,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
        );
      },
    );
  }

  void setMarkerIcon() async {
    _parkingmarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/parking.png");
    _futuremarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/future.png");
    _landmarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/landmark.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  Position position;
  Future<Null> getLoaction() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) mapAvailable = true;
    });
  }

  var mapAvailable = false;
  @override
  Widget build(BuildContext context) {
    _markers.clear();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Map Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: mapAvailable == true
          ? loadMaps()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple[700],
                    ),
                  ),
                  Text(
                    "Turn On Location Manually",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent[200],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: mapAvailable == true
          ? Stack(
              children: [
                SpeedDial(
                  marginRight: MediaQuery.of(context).size.width / 2 - 28,
                  marginBottom: 40,
                  elevation: 20,
                  backgroundColor: Colors.deepPurple,
                  animatedIcon: AnimatedIcons.add_event,
                  curve: Curves.ease,
                  children: [
                    SpeedDialChild(
                      label: "Parking Marks",
                      child: Icon(Icons.local_parking),
                      onTap: () {
                        createDialog("parking", context);
                      },
                    ),
                    SpeedDialChild(
                      label: "Future Marks",
                      child: Icon(Icons.swap_vertical_circle),
                      onTap: () {
                        createDialog("future", context);
                      },
                    ),
                    SpeedDialChild(
                      label: "Land Marks",
                      child: Icon(Icons.collections_bookmark),
                      onTap: () {
                        createDialog("land", context);
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 38, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepPurple),
                    child: IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return Account();
                        }));
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(65, 0, 0, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepPurple),
                    child: IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (bulder) {
                          return AllSaved();
                        }));
                      },
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  displayDeleteWindow(String id, String about, String url, context) {
    return Alert(
        context: context,
        title: about,
        image: Image.network(url),
        buttons: [
          DialogButton(
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              CrudMarkers().deleteMarker(id);
              url = url
                  .replaceAll(
                      new RegExp(
                          r'https://firebasestorage.googleapis.com/v0/b/map-markers-a009b.appspot.com/o/MarkerName%2F'),
                      '')
                  .split('?')[0];
              FirebaseStorage.instance.ref().child(url).delete();
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  upLoadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();

    PickedFile image;
    //Check Permission
    await Permission.photos.request();

    var permissionGranted = await Permission.photos.status;

    if (permissionGranted.isGranted) {
      //Select Image
      image =
          await _picker.getImage(source: ImageSource.gallery, imageQuality: 40);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase

        var snapshot = await _storage
            .ref()
            .child('MarkerName/${DateTime.now()}')
            .putFile(file)
            .onComplete;

        var downloadUrl = await snapshot.ref.getDownloadURL();

        return downloadUrl;
      } else {
        print("Nothing Selected");
      }
    } else {
      print("permission not granted");
    }
  }

  createDialog(String s, context) {
    getLoaction();
    return Alert(
      context: context,
      title: s + " Mark",
      content: Container(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(hintText: "About"),
          onChanged: (value) {
            if (value.isNotEmpty)
              _noteAbout = value;
            else
              _noteAbout = s.toUpperCase();
          },
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "UPLOAD IMAGE",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            imageUrl = await upLoadImage();
            setState(() {});
          },
        ),
        DialogButton(
          child: Text(
            "ADD",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            dynamic mapData = {
              "label": s,
              "coords": new GeoPoint(position.latitude, position.longitude),
              "about": _noteAbout,
              "image": imageUrl
            };
            CrudMarkers().createMarker(mapData, context);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
