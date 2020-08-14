import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:poslabauth/blocs/location/LocationBloc.dart';
import 'package:poslabauth/blocs/user/UserBloc.dart';
import 'package:poslabauth/blocs/user/UserState.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CameraPosition mCameraPosition;
  MapboxMapController mapController;
  List<dynamic> rawCoordinates;

  void _initMainRoute(){
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

  void registerCoordinates(List<LatLng> coordinates){
    setState(() {
      mCameraPosition =  CameraPosition(target: coordinates[0], zoom: 12);
      rawCoordinates = coordinates;
    });
  }

  @override
  Widget build(BuildContext context) {

    BlocProvider.of<LocationBloc>(context).add(LocationSetupEvent());

    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if(state is LocationEstablished){
          registerCoordinates(state.getCoordinates);
        }
      },
      builder: (context, state) {

        return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if(state is UserIsAuthenticated) {
                return Text("Welcome ${state.getUser.name}");
              }else{
                return Text("Welcome user");
              }
            },
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () {

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
    );
  }
}
