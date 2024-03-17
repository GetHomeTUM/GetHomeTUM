class GetHomeLocation {
  final double _lat;
  final double _lng;

  // Creates a GetHomeLocation with the given latitude and longitude.
  GetHomeLocation({required double lat, required double lng}) : _lat = lat, _lng = lng;

  // Creates a GetHomeLocation from a JSON object.
  factory GetHomeLocation.fromJson(Map<String, dynamic> json) {
    return GetHomeLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  // Converts a GetHomeLocation to a JSON-encodable map (default call by dart:convert.jsonEncode()).
  Map<String, dynamic> toJson() {
    return {
      'lat': _lat,
      'lng': _lng,
    };
  }

  //toString method
  @override
  String toString() {
    return 
      '\n GetHomeLocationObject:'
      '\n Latitude: $_lat,'
      '\n Longitude: $_lng'
      '\n';
  }
}