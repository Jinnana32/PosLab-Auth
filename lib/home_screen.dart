import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CameraPosition mCameraPosition;
  MapboxMapController mapController;
  List<dynamic> rawCoordinates;

  String _mapboxAPIKey =
      "sk.eyJ1IjoicG93ZXJvZnBhbmRhIiwiYSI6ImNrZHJia29udDBnZmgycWxpbzNkMTFtZmQifQ.ZPYNj4lf69oPdOxnRdRP1w";

  void getLocations() async {

    //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print("Current position $position");

    var _mapBoxUrl =
        'https://api.mapbox.com/matching/v5/mapbox/driving/122.573309,10.693324;122.574112,10.691926?geometries=geojson&radiuses=25;25&steps=true&access_token=${_mapboxAPIKey}';

    // API CALL TO MAPBOX FOR COORDINATES
    var response = await http.get(Uri.encodeFull(_mapBoxUrl),
        headers: {"Accept": "application/json"});

    Map<String, dynamic> mapboxResp = jsonDecode(response.body);
    Map<String, dynamic> outerEntry = mapboxResp["matchings"][0];
    Map<String, dynamic> geometry = outerEntry["geometry"];

    setState((){
      rawCoordinates = geometry["coordinates"];
    });

  }

  @override
  void initState() {
    super.initState();
    getLocations();
    setState((){
      mCameraPosition =  CameraPosition(target: LatLng(10.693324, 122.573309), zoom: 12);
    });
  }

  void _initMainRoute(){

    // Parse coordinates taken from the admin
    var rawCoords = rawCoordinates.map((coordinates) {
      return LatLng(coordinates[1],coordinates[0]);
    }).toList();

    mapController.addLine(
      LineOptions(
        geometry: rawCoords,
        lineColor: "#000000",
        lineWidth: 5.0,
      ),
    );

  }


  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _initMainRoute();

  }

  void onStyleLoadedCallback() {
    _initMainRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POSLABS Auth"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  //your code
                },
                child: Icon(Icons.settings)),
          ),
        ],
      ),
      body: SafeArea(
          child: mCameraPosition != null && rawCoordinates != null ? MapboxMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: onStyleLoadedCallback,
            initialCameraPosition: mCameraPosition,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            ].toSet(),
          ) : Text("Map is loading"),
      ),
    );
  }
}
