/// Documentation: GetHomeLocation
/// 
/// 2 Variables:
/// - _lat: double    latitude
/// - _lng: double    longitude
/// 
/// 1 factory:
/// - GetHomeLocation.fromJson(Map<String, dynamic> json) - Converts a JSON object to a GetHomeLocation
/// 
/// 2 Methods:
/// - toJson() - Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode())
/// - toString() - Returns a string representation of the object
class GetHomeLocation {
  final double _lat;
  final double _lng;

  /// Creates a GetHomeLocation with the given latitude and longitude.
  GetHomeLocation({required double lat, required double lng}) : _lat = lat, _lng = lng;

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