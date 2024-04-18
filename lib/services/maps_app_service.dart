import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/user_settings.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/user_settings_service.dart';

/// Documentation: MapsAppService
///
/// 3 methods for the Maps App Service:
/// - openPreferredMaps(GetHomeRoute route) - Opens the preferred Maps App based on the app settings for the given route
/// - openRouteInGoogleMaps({GetHomeLocation? start, required GetHomeLocation end}) - Opens Google Maps Directions for the given route
/// - openRouteInAppleMaps({GetHomeLocation? start, required GetHomeLocation end}) - Opens Apple Maps Directions for the given route
class MapsAppService{

  /// Opens the directions in the preferred maps app based on the app's settings.
  /// Parameter:
  /// - route: GetHomeRoute, that should be opened in the maps app.
  /// Notice that only start and end location will be considered for the maps app launch.
  static void openPreferredMaps(GetHomeRoute route) async {
    // only open route if the end location is present
    if (route.endLocation == null) {
      return;
    }

    // get the preferred maps app from the user settings and open the route
    switch (await UserSettingsService.getUserSetting("MapsApp")){
      case MapsApp.apple: _openDirectionsInAppleMaps(start: route.startLocation, end: route.endLocation!);
      case MapsApp.google: _openDirectionsInGoogleMaps(start: route.startLocation, end: route.endLocation!);
    }
  }

  /// Opens Google Maps Directions for the given route with variables:
  ///   - start: optional GetHomeLocation, default is the current location.
  ///   - end: required GetHomeLocation
  static void _openDirectionsInGoogleMaps({GetHomeLocation? start, required GetHomeLocation end}){
    // Check if the start location is passed, if not, use the current location
    if(start == null){
      LocationService.getCurrentLocation().then((value) => start = value);
    }
    
    // Create the Google Maps URL as a Uri object, see: https://developers.google.com/maps/documentation/urls/get-started
    Uri googleMapsUrl = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/dir/',
      queryParameters: {
        'api': '1',
        'origin': '${start!.getLatitude()},${start!.getLongitude()}',
        'destination': '${end.getLatitude()},${end.getLongitude()}',
        'travelmode': 'transit',
        'dir_action': 'navigate',
      }
    );

    // Open the Google Maps URL
    try{
      launchUrl(googleMapsUrl);
    } catch(e){
      debugPrint("Error at launchUrl(googleMapsUrl): $e");
    }
  }


  /// Opens Apple Maps Directions for the given route with variables:
  ///  - start: optional GetHomeLocation, default is the current location.
  ///  - end: required GetHomeLocation
  static void _openDirectionsInAppleMaps({GetHomeLocation? start, required GetHomeLocation end}){
    // Check if the start location is passed, if not, use the current location
    if(start == null){
      LocationService.getCurrentLocation().then((value) => start = value);
    }
    
    // Create the Apple Maps URL as a Uri object, see: https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
    Uri appleMapsUrl = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/maps',
      queryParameters: {
        'saddr': '${start!.getLatitude()},${start!.getLongitude()}', // source address
        'daddr': '${end.getLatitude()},${end.getLongitude()}', // destination address
        'dirflg': 'r', // TransportType: r = transit
        't': 'r', // MapType: r = transit
      }
    );

    // Open the Apple Maps URL
    try{
      launchUrl(appleMapsUrl);
    } catch(e){
      debugPrint("Error at launchUrl(appleMapsUrl): $e");
    }
  }
}