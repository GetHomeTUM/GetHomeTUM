/*
  Documentation: GetHomeLocation

  3 Variables:
  - _id: String     locationId (ie, "home" or "work")
  - _lat: double    latitude
  - _lng: double    longitude

  1 factory:
  - GetHomeLocation.fromJson(Map<String, dynamic> json) - Converts a JSON object to a GetHomeLocation

  2 Methods:
  - toJson() - Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode())
  - getId() - Getter for the locationId
  - toString() - Returns a string representation of the object
*/

class GetHomeLocation {
  final String _id;
  final double _lat;
  final double _lng;

  // Creates a GetHomeLocation with the given latitude and longitude.
  GetHomeLocation({required String id, required double lat, required double lng}) : _id = id, _lat = lat, _lng = lng;

  // Converts a JSON object to a GetHomeLocation
  factory GetHomeLocation.fromJson(Map<String, dynamic> json) {
    return GetHomeLocation(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  // Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode()).
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'lat': _lat,
      'lng': _lng,
    };
  }

  // Getter for the locationId
  String getId() => _id;

  //toString method
  @override
  String toString() {
    return 
      '\n GetHomeLocation:'
      '\n LocationId: $_id,'
      '\n Latitude: $_lat,'
      '\n Longitude: $_lng'
      '\n';
  }
}