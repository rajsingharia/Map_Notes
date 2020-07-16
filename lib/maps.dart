import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_map/add/parkingMarks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

int markerId = 0;
bool isSaved = false;
Set<Marker> marker = HashSet<Marker>();
GoogleMapController _mapController;
BitmapDescriptor _markerIcon;

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    getLoaction();
    setMarkerIcon();
  }

  void setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/parking.png");
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (isSaved == true) {
      markerId++;
      ParkingAdd();
    }
    isSaved = false;
  }

  void ParkingAdd() {
    setState(
      () {
        marker.add(
          Marker(
            markerId: MarkerId(markerId.toString()),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: "Parking",
            ),
            icon: _markerIcon,
          ),
        );
      },
    );
  }

  void getParkingMarks(Position position, context) async {
    isSaved = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ParkingMarks();
        },
      ),
    );
    ParkingAdd();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Map View",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: mapAvailable == true
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16,
              ),
              markers: marker,
              zoomControlsEnabled: true,
            )
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
                        getParkingMarks(position, context);
                      },
                    ),
                    SpeedDialChild(
                      label: "Future Marks",
                      child: Icon(Icons.swap_vertical_circle),
                      onTap: () {},
                    ),
                    SpeedDialChild(
                      label: "Land Marks",
                      child: Icon(Icons.collections_bookmark),
                      onTap: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
