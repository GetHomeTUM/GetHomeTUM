class URLBuilder {
  /// The latitude of the departure location
  double? _latDep;
  /// The longitude of the departure location
  double? _longDep;
  /// The latitude of the destination location
  double? _latDest;
  /// The longitude of the destination location
  double? _longDest;

  /// Constructor of the URLBuilder
  URLBuilder();

  /// Checks if all the parameters are set
  bool areParametersSet() {
    return _latDep != null && _longDep != null && _latDest != null && _longDest != null;
  }

  /// Builds the URI with the parameters set
  /// Throws an exception if not all parameters are set
  /// Returns the URI if all parameters are set
  Uri? buildUri(String apiKey) {
    if (!areParametersSet()) {
      throw Exception('Not all parameters are set to build the URI.');
    }

    return Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: '/maps/api/directions/json',
        queryParameters: {
          'origin': '$_latDep,$_longDep',
          'destination': '$_latDest,$_longDest',
          'mode': 'transit',
          'key': apiKey
        });
  }

  /// Set all the parameters of the URLBuilder
  /// Only use this method if you want to set all the parameters at once
  void setParameters(double latDep, double longDep, double latDest, double longDest) {
    _latDep = latDep;
    _longDep = longDep;
    _latDest = latDest;
    _longDest = longDest;
  }

  /// Sets the latitude of the departure location
  set latDep(double? value) {
    _latDep = value;
  }
  /// Sets the longitude of the departure location
  set longDep(double? value) {
    _longDep = value;
  }
  /// Sets the latitude of the destination location
  set latDest(double? value) {
    _latDest = value;
  }
  /// Sets the longitude of the destination location
  set longDest(double? value) {
    _longDest = value;
  }

}
