import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:gethome/services/local_storage_service.dart';

/// Creates a new App Page of the MapSampleState which displays the Google Map with its markers.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

/// Class for displaying the Google Map with a marker to set the home location.
class MapScreenState extends State<MapScreen> {
  // Completer which is necessary for the Google Maps View
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  // Set of Google Maps markers which are displayed on the Google Map
  Set<Marker> _markers = {};
  // Variable to check whether changes have been made
  bool _markerChanged = false;

  // Default camera position: Garching Forschungszentrum
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.263042, 11.670198),
    zoom: 11,
  );

  /// Updates the set of markers by adding a new marker on the tappedPoint and deleting all the 
  /// other markers with the same label.
  void _updateMarker(LatLng tappedPoint, String label) {
    _markerChangedToTrue();

    setState(() {
      // removing all markers with the given ID from the set
      _markers = _markers.where((Marker marker) => marker.infoWindow.title != label).toSet();
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: label,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  /// Method to save the given location with the given label. It uses the LocalStorageService class.
  void _saveLocation(LatLng position, String label) {
    LocalStorageService.setLocation(label, GetHomeLocation(lat: position.latitude, lng: position.longitude));
    _markerChanged = false;
  }

  /// Method to set the state of _markerChanged and update other instances that are using it. This is important
  /// for the programm to know where changes have been performed and need to be saved.
  void _markerChangedToTrue() {
    setState(() {
      _markerChanged = true;
    });
  }

  /// Loads the location with the given ID into the set of markers. When the function has finished, the loaded
  /// marker will be displayed on the map and it will be shown centered on the map.
  void _loadLocation(String label) async {
    // load location
    GetHomeLocation? location = await LocalStorageService.getLocation(label);
    if (location != null) {
      // add marker of the loaded location
      _updateMarker(LatLng(location.getLatitude(), location.getLongitude()), label);
      // 
      _markerChanged = false;

      // set camera postion to loaded location
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.getLatitude(), location.getLongitude()), // New York coordinates
            zoom: 12,
          ),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Home Location'),
        actions: <Widget>[
          // 'Done' Button which saves the chosen position
          TextButton(
            onPressed: () {
              if (_markerChanged) {
                _saveLocation(_markers.elementAt(0).position, 'Home');
                // go back to home screen
                Navigator.pop(context);
              }
            },
            child: Text(
              'Done',
              style: TextStyle(
                // style of the Button changing depending on marker status
                color: _markerChanged ? Colors.black : Colors.grey,
              )
              ),
          )
        ],
      ),

      // View of the Google Map
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        initialCameraPosition: _kGooglePlex,

        // starting all the following actions when the map is opened
        onMapCreated: (GoogleMapController controller) {
          // necessary controller setting
          _controller.complete(controller);
          // loading the location from the local storage service
          _loadLocation('Home');
        },

        // changing the marker to the tapped point
        onTap: (LatLng tappedPoint) {
          _updateMarker(tappedPoint, 'Home');
        },

        // set of markers on the map
        markers: _markers,
      ),
    );


    
  }
}