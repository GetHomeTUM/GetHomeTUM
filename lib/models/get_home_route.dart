class GetHomeRoute {
  DateTime? _departureTime;
  num? _walkingTimeMinutes;
  num? _changes;
  String? _firstLine;
  String? _typeOfFirstLine;
  String? _locationOfFirstDeparture;
  int? _color;

  /// Creates a GetHomeRoute.
  /// The GetHomeRoute contains the departure time, the walking time to the first transit, the number of changes, the first line, the type of the first line, and the location of the first departure.
  GetHomeRoute({DateTime? departureTime, num? walkingTimeMinutes, num? changes, String? firstLine, String? typeOfFirstLine, String? locationOfFirstDeparture, int? color}) {
    _departureTime = departureTime;
    _walkingTimeMinutes = walkingTimeMinutes;
    _changes = changes;
    _firstLine = firstLine;
    _typeOfFirstLine = typeOfFirstLine;
    _locationOfFirstDeparture = locationOfFirstDeparture;
    _color = color;
  }

  /// Creates a GetHomeRoute from a JSON object.
  /// The JSON object is the response from the Google Directions API.
  factory GetHomeRoute.fromJson(Map<String, dynamic> data) {
    return GetHomeRoute(
      departureTime: computeDepartureTime(data),
      walkingTimeMinutes: computeWalkingTime(data),
      changes: computeTransitSteps(data),
      firstLine: computeFirstLine(data)!.values.first,
      typeOfFirstLine: computeFirstLine(data)!.values.elementAt(1),
      locationOfFirstDeparture: computeFirstLine(data)!.values.last,
      color: computeColor(data)
    );
  }

  /// Calculates the departure time of the route.
  /// The departure time is the time when the first transit departs.
  /// If the first step is a transit, the departure time is the departure time of the transit.
  /// If the first step is walking, the departure time is the departure time of the first transit.
  /// If there is no transit in the route, the departure time is null.
  /// The departure time is in the local time of the departure location.
  /// The departure time is in the format "yyyy-MM-dd HH:mm:ss".
  static DateTime? computeDepartureTime(Map<String, dynamic> data) {
    DateTime? departureTime;
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "TRANSIT" && step['transit_details'] != null && step['transit_details']['departure_time'] != null) {
          departureTime = DateTime.fromMillisecondsSinceEpoch(step['transit_details']['departure_time']['value'] * 1000);
          break;
        }
      }
    }
    return departureTime;
  }

  /// Calculates the walking time to the first transit.
  /// The walking time is the time it takes to walk to the first transit.
  /// If the first step is a transit, the walking time is 0.
  /// If the first step is walking, the walking time is the duration of the walking step.
  /// If there is no transit in the route, the walking time is null.
  /// The walking time is in minutes.
  static num? computeWalkingTime(Map<String, dynamic> data) {
    num? walkingTime;
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "WALKING" && step['duration'] != null) {
          walkingTime = step['duration']['value'];
          break;
        }
      }
    }
    return walkingTime;
  }

  /// Calculates the number of transit steps in the route.
  /// A transit step is a step where the travel mode is "TRANSIT".
  /// Note that a transit step can be a bus, train, tram, etc.
  /// Walking steps are not counted.
  static num? computeTransitSteps(Map<String, dynamic> data) {
    num? transitSteps = 0;
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "TRANSIT") {
          transitSteps = (transitSteps ?? 0) + 1;
        }
      }
    }
    return transitSteps;
  }


  /// Calculates the first line of the route.
  /// The first line is a Map of Data of the first transit.
  /// The first line is null if there is no transit in the route.
  /// The first line contains the name of the first line, the type of the first line, and the location of the first departure.
  /// The first line is in the format {"NameOfFirstLine": "S8", "TypeOfFirstLine": "subway", "LocationOfFirstDeparture": "Garching-Forschungszentrum"}.
  static Map<String, String>? computeFirstLine(Map<String, dynamic> data) {
    Map<String, String>? firstLine = {};
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "TRANSIT" && step['transit_details'] != null && step['transit_details']['line'] != null) {
          //Name of the first line
          firstLine.putIfAbsent('NameOfFirstLine', () => step['transit_details']['line']['short_name'] ?? '');
          //Type of the first line
          firstLine.putIfAbsent('TypeOfFirstLine', () => step['transit_details']['line']['vehicle']['type'] ?? '');
          //Departure Location
          firstLine.putIfAbsent('LocationOfFirstDeparture', () => step['transit_details']['headsign'] ?? '');
          break;
        }
      }
    }
    return firstLine;
  }

  /// Calculates the color of the first line of the route.
  /// The color is an integer in the format 0xAARRGGBB.
  /// The color is null if there is no transit in the route.
  /// The color is null if the color of the first line is not available.
  static int? computeColor(Map<String, dynamic> data) {
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "TRANSIT" ) {
          if( step['transit_details'] != null && step['transit_details']['line'] != null && step['transit_details']['line']['color'] != null) {
            int alpha = 0xFF; // Der Transparenzwert für volle Opazität
            String hex = step['transit_details']['line']['color'].substring(1);
            int color = int.parse(hex, radix: 16);
            int argbInt = (alpha << 24) | color;
            return argbInt;
          }
          break;
        }
      }
    }
    return null;
  }

  /// Returns the departure time of the route.
  DateTime? get departureTime => _departureTime;
  /// Returns the walking time to the first transit.
  num? get walkingTimeMinutes => _walkingTimeMinutes;
  /// Returns the number of changes in the route.
  num? get changes => _changes;
  /// Returns the name of the first line of the route.
  String? get firstLine => _firstLine;
  /// Returns the type of the first line of the route.
  String? get typeOfFirstLine => _typeOfFirstLine;
  /// Returns the location of the first departure of the route.
  String? get locationOfFirstDeparture => _locationOfFirstDeparture;
  /// Returns the color as integer of the first line of the route.
  int? get color => _color;

  /// Returns a string representation of the GetHomeRoute.
  @override
  String toString() {
    return
        '\n departure_time = $_departureTime '
        '\n walking_time = $_walkingTimeMinutes '
        '\n changes = $_changes '
        '\n firstLine = $_firstLine '
        '\n type = $_typeOfFirstLine '
        '\n departureLocation = $_locationOfFirstDeparture '
        '\n color = $_color '
        '\n';
  }

}
