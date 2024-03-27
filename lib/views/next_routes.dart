import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/api_service.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:geolocator/geolocator.dart';

const String _apiKey = 'AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw';

class RouteSample extends StatefulWidget {
  const RouteSample({super.key});

  @override
  State<RouteSample> createState() => RoutesScreen();
}


class RoutesScreen extends State<RouteSample> {
  List<GetHomeRoute>? _nextRoutes;
  LatLng? _homePosition;
  String _errorMessage = 'Unknown error';

  Future<void> _updateHomePostion() async {
    GetHomeLocation? location = await LocalStorageService.loadLocation('Home');
    if (location != null) {
      setState(() {
        _homePosition = LatLng(location.getLatitude(), location.getLongitude());
      });
    }
  }

  void _updateNextRoutes(String apiKey) async {
    if (_homePosition == null) {
      await _updateHomePostion();
    }
    Position? _position = await LocationService.getCurrentLocation();
    if (_position != null && _homePosition != null) {
      List<String> cords = [_position!.latitude.toString(), _position!.longitude.toString(), _homePosition!.latitude.toString(), _homePosition!.longitude.toString()];
      List<GetHomeRoute> list = List.empty();
      try {
        list = await GoogleAPI.getRoutes(apiKey, cords);
      } catch (error) {
        _errorMessage = 'Couldn\'t connect to server.';
      }
      setState(() {
        _nextRoutes = list;
      });
    } else if (_position == null) {
      _errorMessage = 'Error getting device\'s location.';
    } else {
      _errorMessage = 'Setup your home location to see connection.';
    }
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next three routes'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Home Location:\n${_homePosition == null ? 'Not available' : _homePosition!.latitude}, ${_homePosition == null ? 'Not available' : _homePosition!.longitude}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(),
          // String of the List of connections to be displayed here
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            MyListTile(route: _nextRoutes![0])
          ),
          const Divider(),
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            MyListTile(route: _nextRoutes![1])
          ),
          const Divider(),
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            MyListTile(route: _nextRoutes![2])
          ),
          const Divider(),
        ],
      ),
      // refresh button
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        _updateNextRoutes(_apiKey);
      },
      child: const Icon(Icons.refresh),
    ),
    );
  }
}

/// Class of a ListTile that takes a GetHomeRoute and returns a complete designed
/// ListTile that displays the route's data.
class MyListTile extends StatelessWidget {
  final GetHomeRoute route;

  MyListTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (route.color == null ? Colors.blue : Color(route.color!)), // Farbe des Rechtecks
              borderRadius: BorderRadius.circular(5), // Runden des Rechtecks
            ),
            child: Text(
              route.firstLine.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Icon(Icons.arrow_forward_ios,
          size: 14),
          Text(
            '+${(route.changes == null || route.changes == 0 ? 1 : route.changes!) - 1}',
            style: TextStyle(fontSize: 14), // Kleinerer Text für changes
          ),
          SizedBox(width: 20),
          Text(
            extractTime(route.departureTime!),
            style: TextStyle(fontSize: 25), // Größerer Text für departureTime
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_walk,), // Icon einer laufenden Person
          SizedBox(width: 5), // Abstand zwischen Text und Icon
          Text(
            '${(route.walkingTimeMinutes == null ? 0 : route.walkingTimeMinutes!) ~/ 60} min',
            style: TextStyle(fontSize: 20), // Kleinerer Text für walkingTimeMinutes
          ),
        ],
      ),
    );
  }
}


/// Additional method to convert a DateTime to a String that consists only of hours
/// and minutes.
String extractTime(DateTime dateTime) {
  // Konvertiere DateTime in einen String
  String dateTimeString = dateTime.toLocal().toString();
  
  // Extrahiere nur die Zeit
  String timeString = dateTimeString.split(' ')[1];

  return '${timeString.split(':')[0]}:${timeString.split(':')[1]}';
}