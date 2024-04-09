import 'package:geolocator/geolocator.dart';

/// GetHomeLocation is a class that represents a location with latitude and longitude.
/// It's goal is to provide a generic way to handle locations in the app and standardize datatypes
class GetHomeLocation {
  final double _lat;
  final double _lng;

  /// Constructor:Creates a GetHomeLocation with the given latitude and longitude.
  GetHomeLocation({required double lat, required double lng}) : _lat = lat, _lng = lng;

  /// Creates a GetHomeLocation from a Position object (from package:geolocator_platform_interface)
  factory GetHomeLocation.fromPosition(Position position) {
    return GetHomeLocation(lat: position.latitude, lng: position.longitude);
  }

  /// Creates an empty GetHomeLocation with lat and lng set to 0.
  factory GetHomeLocation.empty() {
    return GetHomeLocation(lat: 0, lng: 0);
  }


  /// Converts a JSON object to a GetHomeLocation
  factory GetHomeLocation.fromJson(Map<String, dynamic> json) {
    return GetHomeLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  /// Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode()).
  Map<String, dynamic> toJson() {
    return {
      'lat': _lat,
      'lng': _lng,
    };
  }

  // Returns the distance in km
  double getDistanceTo(GetHomeLocation location) {
    return Geolocator.distanceBetween(_lat, _lng, location._lat, location._lng);
  }

  // Returns true if the location is empty (lat and lng are 0)
  bool isEmpty() {
    return _lat == 0 && _lng == 0;
  }

  // Getters
  double getLatitude() => _lat;
  double getLongitude() => _lng;

  /// toString method
  @override
  String toString() {
    return 
      '\n GetHomeLocation:'
      '\n Latitude: $_lat,'
      '\n Longitude: $_lng'
      '\n';
  }
}