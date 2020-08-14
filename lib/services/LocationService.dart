
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class LocationService {

  String _mapboxAPIKey =
      "sk.eyJ1IjoicG93ZXJvZnBhbmRhIiwiYSI6ImNrZHJia29udDBnZmgycWxpbzNkMTFtZmQifQ.ZPYNj4lf69oPdOxnRdRP1w";

  Future< List<LatLng>> getCoordinates() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Position taken ${position}");
    LatLng randomPosition = getRandomPosition(position.longitude, position.latitude, 50);
    print("Random Position taken ${randomPosition}");
    var _mapBoxUrl =
        'https://api.mapbox.com/matching/v5/mapbox/driving/${position.longitude},${position.latitude};${randomPosition.longitude},${randomPosition.latitude}?geometries=geojson&radiuses=25;25&steps=true&access_token=${_mapboxAPIKey}';

    var response = await http.get(Uri.encodeFull(_mapBoxUrl),
        headers: {"Accept": "application/json"});

    Map<String, dynamic> mapboxResp = jsonDecode(response.body);
    Map<String, dynamic> outerEntry = mapboxResp["matchings"][0];
    Map<String, dynamic> geometry = outerEntry["geometry"];
    List<dynamic> rawCoordinates = geometry["coordinates"];

    return rawCoordinates.map((coordinates) {
      return LatLng(coordinates[1],coordinates[0]);
    }).toList();

  }

  LatLng getRandomPosition(double x0, double y0, int radius) {
    Random random = Random();

    // Convert radius from meters to degrees
    double radiusInDegrees = radius / 111000.0;

    double u = random.nextDouble();
    double v = random.nextDouble();
    double w = radiusInDegrees * sqrt(u);
    double t = 2 * pi * v;
    double x = w * cos(t);
    double y = w * sin(t);

    // Adjust the x-coordinate for the shrinking of the east-west distances
    double new_x = x / cos(radians(y0));

    double longitude = new_x + x0;
    double latitude = y + y0;
    return LatLng(latitude, longitude);
}

}