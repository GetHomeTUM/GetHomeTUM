import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Documentation: MapsAppService
///
/// 1 Method for the Maps App Service:
/// - openRouteInGoogleMaps({GetHomeLocation? start, required GetHomeLocation end}) - Opens Google Maps Directions for the given route
/// - openRouteInAppleMaps({GetHomeLocation? start, required GetHomeLocation end}) - Opens Apple Maps Directions for the given route
class MapsAppService{
  /// Opens Google Maps Directions for the given route with variables:
  ///   - start: optional GetHomeLocation, default is the current location.
  ///   - end: required GetHomeLocation
  static void openRouteInGoogleMaps({GetHomeLocation? start, required GetHomeLocation end}){
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
  static void openRouteInAppleMaps({GetHomeLocation? start, required GetHomeLocation end}){
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