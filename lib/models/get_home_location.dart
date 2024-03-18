/// Documentation: GetHomeLocation
/// 
/// 3 Variables:
/// - _name: String   locationName (ie, "home" or "work")
/// - _lat: double    latitude
/// - _lng: double    longitude
/// 
/// 1 factory:
/// - GetHomeLocation.fromJson(Map<String, dynamic> json) - Converts a JSON object to a GetHomeLocation
/// 
/// 2 Methods:
/// - toJson() - Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode())
/// - getName() - Getter for the locationName
/// - toString() - Returns a string representation of the object
class GetHomeLocation {
  final String _name;
  final double _lat;
  final double _lng;

  /// Creates a GetHomeLocation with the given latitude and longitude.
  GetHomeLocation({required String name, required double lat, required double lng}) : _name = name.trim().toLowerCase(), _lat = lat, _lng = lng;

  /// Converts a JSON object to a GetHomeLocation
  factory GetHomeLocation.fromJson(Map<String, dynamic> json) {
    return GetHomeLocation(
      name: json['name'].toString().trim().toLowerCase(),
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  /// Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode()).
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'lat': _lat,
      'lng': _lng,
    };
  }

  // Getters
  String getName() => _name;
  double getLatitude() => _lat;
  double getLongitude() => _lng;

  /// toString method
  @override
  String toString() {
    return 
      '\n GetHomeLocation:'
      '\n LocationName: $_name,'
      '\n Latitude: $_lat,'
      '\n Longitude: $_lng'
      '\n';
  }
}