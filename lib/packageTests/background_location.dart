import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class BackgroundLocationScreen extends StatefulWidget {
  @override
  _BackgroundLocationScreenState createState() =>
      _BackgroundLocationScreenState();
}

class _BackgroundLocationScreenState extends State<BackgroundLocationScreen> {
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  String time = "waiting...";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location " + location.toMap().toString());
    });
  }

  dynamic _getLocationUpdates(Location location) {
    setState(() {
      this.latitude = location.latitude.toString();
      this.longitude = location.longitude.toString();
      this.accuracy = location.accuracy.toString();
      this.altitude = location.altitude.toString();
      this.bearing = location.bearing.toString();
      this.speed = location.speed.toString();
      this.time =
          DateTime.fromMillisecondsSinceEpoch(location.time.toInt()).toString();
    });

    final firebaseUrl = Uri.parse(
        'https://package-playground-default-rtdb.firebaseio.com/locations.json');

    http.post(
      firebaseUrl,
      body: json.encode({
        "latitude": location.latitude,
        "longitude": location.longitude,
        "speed": location.speed,
        "accuracy": location.accuracy,
        "altitude": location.altitude,
        "time": location.time,
      }),
    );
  }

  Future<void> startLocationService() async {
    await BackgroundLocation.setAndroidNotification(
      title: "Background service is running",
      message: "Background location in progress",
      icon: "@mipmap/ic_launcher",
    );

    await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(distanceFilter: 20);

    BackgroundLocation.getLocationUpdates(_getLocationUpdates);

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Location Service'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            locationData("Latitude: " + latitude),
            locationData("Longitude: " + longitude),
            locationData("Altitude: " + altitude),
            locationData("Accuracy: " + accuracy),
            locationData("Bearing: " + bearing),
            locationData("Speed: " + speed),
            locationData("Time: " + time),
            ElevatedButton(
                onPressed: startLocationService,
                child: Text("Start Location Service")),
            ElevatedButton(
                onPressed: () {
                  BackgroundLocation.stopLocationService();
                },
                child: Text("Stop Location Service")),
            ElevatedButton(
                onPressed: () {
                  getCurrentLocation();
                },
                child: Text("Get Current Location")),
            LatestLocationsMap(),
          ],
        ),
      ),
    );
  }
}

class LatestLocationsMap extends StatelessWidget {
  Future<List<LatLng>> fetchLocations() async {
    final List<LatLng> locations = [];
    try {
      final firebaseUrl = Uri.parse(
          'https://package-playground-default-rtdb.firebaseio.com/locations.json');

      final response = await http.get(firebaseUrl);

      final Map<String, dynamic> responseBody = json.decode(response.body);

      responseBody.forEach((key, value) {
        locations.add(LatLng(value['latitude'], value['longitude']));
      });
    } catch (err) {
      print(err);
      throw err;
    }

    return Future.value(locations);
  }

  LatLng getCenter(List<LatLng> locations) {
    if (locations.length > 2) {
      final int index = (locations.length / 2).floor();

      return locations[index];
    }

    if (locations.isEmpty) {
      return LatLng(51.5, -0.09);
    }

    return locations.first;
  }

  List<Marker> getMarkers(List<LatLng> locations) {
    final List<Marker> markers = [];

    locations.forEach((location) {
      markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: location,
        builder: (ctx) => Container(
          child: Icon(
            Icons.circle,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ));
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      height: 600,
      width: double.infinity,
      child: FutureBuilder(
        future: fetchLocations(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ocorreu um erro'),
            );
          }

          final List<LatLng> locations = snapshot.data;

          final LatLng center = getCenter(locations);

          return FlutterMap(
            options: MapOptions(
              center: center,
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points: locations,
                    strokeWidth: 4.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              MarkerLayerOptions(
                markers: getMarkers(locations),
              ),
            ],
          );
        },
      ),
    );
  }
}
