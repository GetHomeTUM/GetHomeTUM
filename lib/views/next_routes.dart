import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/api_service.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'package:gethome/services/update_widget_service.dart';
import 'package:gethome/views/list_tile_of_route.dart';
import 'package:home_widget/home_widget.dart';

class RoutesScreen extends StatefulWidget {
  final String _apiKey;

  const RoutesScreen(this._apiKey, {super.key});

  @override
  State<RoutesScreen> createState() => RoutesScreenState(_apiKey);
}

class RoutesScreenState extends State<RoutesScreen> {
  // list where the next three GetHomeRoutes are saved in
  List<GetHomeRoute>? _nextRoutes;
  
  // GetHomeLocation object of the home location
  GetHomeLocation? _homeLocation;
  // GetHomeLocation object of the current location
  GetHomeLocation? _currentLocation;

  // String that is displayed in case of an error
  String _errorMessage = 'Unknown error';
  
  // API key
  final String _apiKey;
  
  // bool the check wether at home or not. necessary for the widget and to save power resources with api calls.
  bool atHome = false;
  
  // global key that is necessary for the widget's image when rendering
  final _globalKey = GlobalKey();

  // constructor that takes the API key
  RoutesScreenState(this._apiKey);

  /// Method that is called when the object is created. Makes the first API call.
  @override
  void initState() {
    super.initState();

    // setting the group id of the widget -> necessary to send data to it (ios)
    HomeWidget.setAppGroupId('group.flutter_test_widget');

    // first refresh of the GetHomeRoutes displayed
    _updateNextRoutes(_apiKey);
  }

  /// Method that updates the home location first uses the device's location to update the attribute of the list
  /// of the GetHomeRoutes. If an error occurs while performing one of the actions, the specific error message
  /// will be stored in '_errorMessage'.
  void _updateNextRoutes(String apiKey) async {
    // updating the home position if it's not yet present
    _homeLocation ??= await LocalStorageService.loadLocation('Home');
    if(_homeLocation == null){
      setState(() {
        _errorMessage = 'Home location not set.';
      });
      return;
    }


    // obtaining the device's location
    setState(() {
      _errorMessage = 'Waiting for the device\'s location...';
    });
    GetHomeLocation updatedCurrentLocation = await LocationService.getCurrentLocation().catchError((error){
      debugPrint("Error at jsonEncode(location): $error");
      return GetHomeLocation.empty();
    });
    if(updatedCurrentLocation.isEmpty()){
      setState(() {
        _errorMessage = 'Failed to get the current device\'s location.';
      });
      return;
    }

    // check wether the position and the homePosition are approximately the same
    // a distance less than 0.25 km is considered as being at home
    if(_currentLocation!.getDistanceTo(_homeLocation!) < 0.25){
      atHome = true;
      setState(() {
        _errorMessage = 'No connections available. You are at home.';
      });
    } else {
      atHome = false;
    }
    
    
    // if not at home, making the API call using both the device's location and the home location
    if (!atHome) {
      // list of coordinates
      List<String> cords = [
        _currentLocation!.getLatitude().toString(),
        _currentLocation!.getLatitude().toString(),
        _homeLocation!.getLongitude().toString(),
        _homeLocation!.getLatitude().toString()
      ];
      List<GetHomeRoute> list = List.empty();
      setState(() {
        _errorMessage = 'Searching for connections...';
      });
      try {
        // API call
        list = await GoogleAPI.getRoutes(apiKey, cords);
      } catch (error) {
        setState(() {
          _errorMessage = 'No connection found.';
        });
      }
      // setting the value of the _nextRoutes list
      setState(() {
        _nextRoutes = list;
      });
    }

    // call for updating the home_widget
    UpdateWidgetService.updateHomeWidget(_globalKey, _nextRoutes, atHome);
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
              child: Text(
                'Home Location:\n${_homeLocation == null ? 'Not available' : _homeLocation!.getLatitude()}, ${_homeLocation == null ? 'Not available' : _homeLocation!.getLongitude()}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(),

          // String of the List of connections to be displayed here
          // If some values are not present, the _errorMessage is displayed. Else the first route is displayed in a ListTile
          (_nextRoutes == null || _nextRoutes!.isEmpty
              ? Center(
                  child: Text(_errorMessage),
                )
              : RouteListTile(route: _nextRoutes![0], size: Size.large)),
          const Divider(),

          // displaying the second route (in the same way as the first route of the list)
          (_nextRoutes == null || _nextRoutes!.isEmpty
              ? Center(
                  child: Text(_errorMessage),
                )
              : RouteListTile(route: _nextRoutes![1], size: Size.large)),
          const Divider(),

          // displaying the third route (in the same way as the first route of the list)
          (_nextRoutes == null || _nextRoutes!.isEmpty
              ? Center(
                  child: Text(_errorMessage),
                )
              : RouteListTile(route: _nextRoutes![2], size: Size.large)),
          const Divider(),

          // the following commented code is only for testing. it shows a preview of the widget.
          // uncomment to view it (also don't forget to import the class):
          // if (_nextRoutes != null)
          //  ListTile(title: RouteWidget(key: _globalKey, nextRoutes: _nextRoutes!))

          // create an empty Sized Box for getting the size for the global key (important for rendering the image of the widget)
          SizedBox(
              key: _globalKey,
              height: RouteListTile.width,
              width: RouteListTile.width)
        ],
      ),

      // refresh button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _updateNextRoutes(_apiKey);
        },
        backgroundColor: const Color.fromARGB(255, 202, 229, 249),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
