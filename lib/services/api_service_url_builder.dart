class URLBuilder {
  /// Builds the Uri for the Google Maps API
  /// Requires the API key and the coordinates of the origin and destination
  /// Coordinates are in the format [latitudeOrigin, longitudeQrigin, latitudeDestination, longitudeDestination]
  static Uri buildUri(String apiKey, List<String> cords, DateTime departureTime) {
    return Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: '/maps/api/directions/json',
        queryParameters: {
          'origin': '${cords[0]},${cords[1]}',
          'destination': '${cords[2]},${cords[3]}',
          'mode': 'transit',
          'departure_time': (departureTime.millisecondsSinceEpoch ~/ 1000).toString(),
          'key': apiKey
        });
  }
}
