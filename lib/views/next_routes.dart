import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/api_service.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:geolocator/geolocator.dart';


class RouteSample extends StatefulWidget {
  final String _apiKey;

  const RouteSample(this._apiKey, {super.key});

  @override
  State<RouteSample> createState() => RoutesScreen(_apiKey);
}


class RoutesScreen extends State<RouteSample> {
  // list where the next three GetHomeRoutes are saved in
  List<GetHomeRoute>? _nextRoutes;
  // LatLng object that stores the home location once it's available
  LatLng? _homePosition;
  // String that is displayed in case of an error
  String _errorMessage = 'Unknown error';
  // API key
  final String _apiKey;

  // constructor that takes the API key
  RoutesScreen(this._apiKey);

  /// Method that is called when the object is created. Makes the first API call.
  @override
  void initState(){
    super.initState();
    _updateNextRoutes(_apiKey);
  }

  /// Future that loads the home location and stores it in the attribute _homePosition.
  Future<void> _updateHomePostion() async {
    GetHomeLocation? location = await LocalStorageService.loadLocation('Home');
    if (location != null) {
      setState(() {
        _homePosition = LatLng(location.getLatitude(), location.getLongitude());
      });
    }
  }

  /// Method that updates the home location first uses the device's location to update the attribute of the list
  /// of the GetHomeRoutes. If an error occurs while performing one of the actions, the specific error message 
  /// will be stored in '_errorMessage'.
  void _updateNextRoutes(String apiKey) async {

    // updating the home position if it's not yet present
    if (_homePosition == null) {
      await _updateHomePostion();
    }

    // obtaining the device's location
    Position? position;
    await LocationService.getCurrentLocation()
      .then((value) => position = value)
      .catchError((error) {
        position = null;
        return Future.value(position);
      });

    // making the API call using both the device's location and the home location
    if (position != null && _homePosition != null) {
      // list of coordinates
      List<String> cords = [position!.latitude.toString(), position!.longitude.toString(), _homePosition!.latitude.toString(), _homePosition!.longitude.toString()];
      List<GetHomeRoute> list = List.empty();
      try {
        // API call
        list = await GoogleAPI.getRoutes(apiKey, cords);
      } catch (error) {
        _errorMessage = 'No connection found.';
      }
      // setting the value of the _nextRoutes list
      setState(() {
        _nextRoutes = list;
      });
    } else if (position == null) {
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
        // list of widgets that are displayed in the given order
        children: <Widget>[
          // displaying the coordinates of the home location
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
          // If some values are not present, the _errorMessage is displayed. Else the first route is displayed in a ListTile
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            MyListTile(route: _nextRoutes![0])
          ),
          const Divider(),

          // displaying the second route (in the same way as the first route of the list)
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            MyListTile(route: _nextRoutes![1])
          ),
          const Divider(),

          // displaying the third route (in the same way as the first route of the list)
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
  // route to be displayed
  final GetHomeRoute route;

  MyListTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // rectangle with the name of the first line inside
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

          // displaying the number of changes
          Icon(Icons.arrow_forward_ios,
          size: 14),
          Text(
            '+${(route.changes == null || route.changes == 0 ? 1 : route.changes!) - 1}',
            style: TextStyle(fontSize: 14), // Kleinerer Text für changes
          ),

          // empty space for separation
          SizedBox(width: 20),

          // displaying the departure time of the first line
          Text(
            extractTime(route.departureTime!),
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          // displaying the walking time and a walking person icon
          Icon(Icons.directions_walk,),
          SizedBox(width: 5),
          Text(
            '${(route.walkingTimeMinutes == null ? 0 : route.walkingTimeMinutes!) ~/ 60} min',
            style: TextStyle(fontSize: 20),
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