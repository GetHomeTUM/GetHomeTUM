import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:gethome/services/local_storage_service.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  // Variable to check whether a marker has been set
  bool _markerChanged = false;
  LocalStorageService localStorageService = LocalStorageService();

  // default camera position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.263042, 11.670198),
    zoom: 14.4746,
  );

  /// Updates the set of markers by adding a new marker on the tappedPoint and deleting all the 
  /// other markers with the same label.
  void _updateMarker(LatLng tappedPoint, String label) {
    setState(() {
      _markerChangedToTrue();
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

  // saving a position with the new LocalStorageService class
  void _saveLocation(LatLng position, String label) {
    localStorageService.saveLocation(label, GetHomeLocation(lat: position.latitude, lng: position.longitude));
  }

  // method to Set the state of _markerChanged and update other instances that are using it
  void _markerChangedToTrue() {
    setState(() {
      _markerChanged = true;
    });
  }

  /// Loads the location with the given ID into the set of markers.
  void _loadLocation(String label) async {
    GetHomeLocation ?location = await localStorageService.loadLocation(label);
    if (location != null) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: LatLng(location.toJson()['lat'], location.toJson()['lng']),
          infoWindow: InfoWindow(
            title: label,
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Home Location'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          // 'Done' Button which saves the chosen position
          TextButton(
            onPressed: () {
              if (_markerChanged) {
                _saveLocation(_markers.elementAt(0).position, 'Home');
                _markerChanged = false;
                // go back to home screen
                Navigator.pop(context);
              }
            },
            child: Text(
              'Done',
              style: TextStyle(
                // style of the Button changing depending on marker status
                color: _markerChanged ? Colors.white : Colors.grey,
              )
              ),
          )
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        // starting all the following actions when the map is opened
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _loadLocation('Home');
          _markerChanged = false;
        },
        onTap: (LatLng tappedPoint) {
          _updateMarker(tappedPoint, 'Home');
        },
        markers: _markers,
      ),
    );


    
  }
}