import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';

class GetHomeRoute {
  DateTime? _departureTime;
  num? _walkingTimeMinutes;
  num? _walkingDistanceMeters;
  num? _changes;
  String? _firstLineName;
  String? _firstLineType;
  Color? _firstLineColor;
  String? _firstLineDepartureLocationName;
  GetHomeLocation? _startLocation;
  GetHomeLocation? _endLocation;
  num? _durationMinutes;

  /// Creates a GetHomeRoute.
  /// The GetHomeRoute contains the departure time, the walking time to the first transit, the number of changes, the first line name, the type of the first line, the color of the first line, the name of the first lines departure location, the start location of the route and the end location of the route
  GetHomeRoute({DateTime? departureTime, num? walkingTimeMinutes, num? walkingDistanceMeters, num? changes, String? firstLineName, String? firstLineType, Color? firstLineColor, String? firstLineDepartureLocationName, GetHomeLocation? startLocation, GetHomeLocation? endLocation, num? durationMinutes}) {
    _departureTime = departureTime;
    _walkingTimeMinutes = walkingTimeMinutes;
    _walkingDistanceMeters = walkingDistanceMeters;
    _changes = changes;
    _firstLineName = firstLineName;
    _firstLineType = firstLineType;
    _firstLineColor = firstLineColor;
    _firstLineDepartureLocationName = firstLineDepartureLocationName;
    _startLocation = startLocation;
    _endLocation = endLocation;
    _durationMinutes = durationMinutes;
  }

  /// Creates a GetHomeRoute from a JSON object.
  /// The JSON object is the response from the Google Directions API.
  factory GetHomeRoute.fromJson(Map<String, dynamic> data) {
    return GetHomeRoute(
      departureTime: computeDepartureTime(data),
      walkingTimeMinutes: computeWalkingTime(data),
      walkingDistanceMeters: computeWalkingDistance(data),
      changes: computeTransitSteps(data),
      firstLineName: computeFirstLine(data)!.values.first,
      firstLineType: computeFirstLine(data)!.values.elementAt(1),
      firstLineColor: computeFirstLineColor(data),
      firstLineDepartureLocationName: computeFirstLine(data)!.values.last,
      startLocation: computeStartLocation(data),
      endLocation: computeEndLocation(data),
      durationMinutes: computeDuration(data),
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

  /// Calculates the walking distance to the first transit.
  static num? computeWalkingDistance(Map<String, dynamic> data) {
    num? walkingDistance;
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "WALKING" && step['distance'] != null) {
          walkingDistance = step['distance']['value'];
          break;
        }
      }
    }
    return walkingDistance;
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
  /// The color is null if there is no transit in the route.
  /// The color is null if the color of the first line is not available.
  static Color? computeFirstLineColor(Map<String, dynamic> data) {
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      for (var step in data['routes'][0]['legs'][0]['steps']) {
        if(step != null && step['travel_mode'] == "TRANSIT" ) {
          if( step['transit_details'] != null && step['transit_details']['line'] != null && step['transit_details']['line']['color'] != null) {
            int alphaHex = 0xFF000000; // Der Transparenzwert für volle Opazität
            String rgb = step['transit_details']['line']['color'].substring(1);
            int rgbHex = int.parse(rgb, radix: 16);
            return Color(alphaHex+rgbHex);
          }
          break;
        }
      }
    }
    return null;
  }

  /// Calculates the start location from the Json Data
  static GetHomeLocation? computeStartLocation(Map<String, dynamic> data) {
    return GetHomeLocation.fromJson(data['routes'][0]['legs'][0]['start_location']);
  }

  /// Calculates the end location from the Json Data
  static GetHomeLocation? computeEndLocation(Map<String, dynamic> data) {
    return GetHomeLocation.fromJson(data['routes'][0]['legs'][0]['end_location']);
  }

  /// Calculates the duration of the route.
  static num? computeDuration(Map<String, dynamic> data) {
    if (data['routes'] != null && data['routes'][0]['legs'] != null) {
      return data['routes'][0]['legs'][0]['duration']['value'];
    }
    return null;
  }


  /// Returns the departure time of the route.
  DateTime? get departureTime => _departureTime;
  /// Returns the walking time to the first transit.
  num? get walkingTimeMinutes => _walkingTimeMinutes;
  /// Returns the walking distance to the first transit.
  num? get walkingDistanceMeters => _walkingDistanceMeters;
  /// Returns the number of changes in the route.
  num? get changes => _changes;
  /// Returns the name of the first line of the route.
  String? get firstLineName => _firstLineName;
  /// Returns the type of the first line of the route.
  String? get typeOfFirstLine => _firstLineType;
  /// Returns the color of the first line of the route.
  Color? get firstLineColor => _firstLineColor;
  /// Returns the location of the first departure of the route.
  String? get firstLineDepartureLocationName => _firstLineDepartureLocationName;
  /// Returns the start location of the route.
  GetHomeLocation? get startLocation => _startLocation;
  /// Returns the end location of the route.
  GetHomeLocation? get endLocation => _endLocation;
  /// Returns the duration of the route.
  num? get durationMinutes => _durationMinutes;


  /// Returns a string representation of the GetHomeRoute.
  @override
  String toString() {
    return
        '\n startLocation = $_startLocation '
        '\n endLocation = $_endLocation '
        '\n departure_time = $_departureTime '
        '\n walking_time = $_walkingTimeMinutes min'
        '\n walking_distance = $_walkingDistanceMeters m'
        '\n changes = $_changes '
        '\n firstLine = $_firstLineName '
        '\n firstLineType = $_firstLineType '
        '\n firstLineColor = $_firstLineColor '
        '\n firstLineDepartureLocation = $_firstLineDepartureLocationName '
        '\n duration = $_durationMinutes '
        '\n';
  }

}
