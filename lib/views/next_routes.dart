import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/api_service.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'package:gethome/views/home_widget.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gethome/views/list_tile_of_route.dart';

import 'package:home_widget/home_widget.dart';


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

  final _globalKey = GlobalKey();

  // constructor that takes the API key
  RoutesScreen(this._apiKey);

  /// Method that is called when the object is created. Makes the first API call.
  @override
  void initState(){
    super.initState();

    // setting the group id of the widget -> necessary to send data to it (ios)
    HomeWidget.setAppGroupId('group.flutter_test_widget');

    // first refresh of the GetHomeRoutes displayed
    _updateNextRoutes(_apiKey);
  }

  /// Future that loads the home location and stores it in the attribute _homePosition.
  Future<void> _updateHomePostion() async {
    GetHomeLocation? location = await LocalStorageService.loadLocation('Home');
    if (location != null) {
      setState(() {
        _homePosition = LatLng(location.getLatitude(), location.getLongitude());
        _errorMessage = 'Waiting for the device\'s location...';
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
      setState(() {
        _errorMessage = 'Searching for connections...';
      });
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

    // call for updating the home_widget
    updateHomeWidget(_globalKey, _nextRoutes);
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
            RouteListTile(route: _nextRoutes![0], size: Size.large)
          ),
          const Divider(),

          // displaying the second route (in the same way as the first route of the list)
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            RouteListTile(route: _nextRoutes![1], size: Size.large)
          ),
          const Divider(),

          // displaying the third route (in the same way as the first route of the list)
          (_nextRoutes == null || _nextRoutes!.isEmpty ?
            Center(
              child: Text(_errorMessage),
            )
            :
            RouteListTile(route: _nextRoutes![2], size: Size.large)
          ),
          const Divider(),

          // the following commented code is only for testing. it shows a preview of the widget.
          // uncomment to view it:
          // if (_nextRoutes != null)
          //  ListTile(title: RouteWidget(key: _globalKey, nextRoutes: _nextRoutes!))

          // create an empty Sized Box for getting the size for the global key (important for rendering the image of the widget)
          SizedBox(key: _globalKey, height: RouteListTile.width, width: RouteListTile.width)
        ],
      ),

      // refresh button
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        _updateNextRoutes(_apiKey);
      },
      child: const Icon(Icons.refresh),
    ),
    );
  }
}