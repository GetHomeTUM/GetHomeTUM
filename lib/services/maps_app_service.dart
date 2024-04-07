import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gethome/models/get_home_route.dart';

/// Documentation: MapsAppService
///
/// 1 Method for the Maps App Service:
/// - openRouteInGoogleMaps(GetHomeLocation start, GetHomeLocation end, DateTime departureTime): Opens Google Maps Directions for the given Start/End location and the departure time.
class MapsAppService{
  /// Method that takes a GetHomeRoute and calls the openRouteInGoogleMaps Method that lauches Google
  /// Maps with for the given parameters. If the start or end location are not present, it will not
  /// launch Google Maps. If the departure time is not present, it will take the current time.
  static void openRouteInGoogleMaps(GetHomeRoute route) {
    if (route.startLocation != null && route.endLocation != null) {
      openLocationDirectionsInGoogleMaps(route.startLocation!, route.endLocation!, route.departureTime ?? DateTime.now());
    }
  }

  /// Opens Google Maps Directions for the given Start/End location and the departure time.
  static void openLocationDirectionsInGoogleMaps(GetHomeLocation start, GetHomeLocation end, DateTime departureTime){
    // Create the Google Maps URL as a Uri object, see: https://developers.google.com/maps/documentation/urls/get-started
    Uri googleMapsUrl = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/dir/',
      queryParameters: {
        'api': '1',
        'origin': '${start.getLatitude()},${start.getLongitude()}',
        'destination': '${end.getLatitude()},${end.getLongitude()}',
        'travelmode': 'transit',
        'dir_action': 'navigate',
        'date': '${departureTime.year}-${departureTime.month}-${departureTime.day}',
        'time': '${departureTime.hour}:${departureTime.minute}',
      }
    );

    // Open the Google Maps URL
    try{
      launchUrl(googleMapsUrl);
    } catch(e){
      debugPrint("Error at launchUrl(googleMapsUrl): $e");
    }
  }
}