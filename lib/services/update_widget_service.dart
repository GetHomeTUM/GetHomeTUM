import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:gethome/views/list_tile_of_route.dart';
import 'package:gethome/views/route_widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'package:gethome/services/api_service.dart';


class UpdateWidgetService {

  /// Method for updating the background widget. It needs only an API key for the Google Maps API.
  static Future<void> updateBackgroundWidget(String apiKey) async {
    // Attributes
    List<GetHomeRoute>? nextRoutes;
    GetHomeLocation? homePosition;
    GetHomeLocation? currentPosition;

    // getting home location
    homePosition = await LocalStorageService.loadLocation('Home');

    // getting current location
    if (Platform.isIOS) {
      //currentPosition = GetHomeLocation(lat: 48.15003, lng: 11.54555);
      currentPosition = await LocalStorageService.loadLocation('Current');
    } else {
      await LocationService.getCurrentLocation()
        .then((value) => currentPosition = GetHomeLocation(lat: value.latitude, lng: value.longitude))
        .catchError((error) {
      currentPosition = null;
      return Future.value(currentPosition);
    });
    }

    // api call
    if (currentPosition != null && homePosition != null) {
      // list of coordinates
      List<String> cords = [
        currentPosition!.getLatitude().toString(),
        currentPosition!.getLongitude().toString(),
        homePosition.getLatitude().toString(),
        homePosition.getLongitude().toString()
      ];
      List<GetHomeRoute> list = List.empty();
      try {
        list = await GoogleAPI.getRoutes(apiKey, cords);
      } catch (error) {
        print(error);
      }
      // setting the value of the _nextRoutes list
      nextRoutes = list;
    }
    
    // updating widget's general data
    await HomeWidget.setAppGroupId('group.flutter_test_widget');
    await HomeWidget.saveWidgetData('time', extractTime(DateTime.now())); // for debug purposes
    await HomeWidget.saveWidgetData('home_lat', homePosition?.getLatitude().toString());
    await HomeWidget.saveWidgetData('home_lng', homePosition?.getLongitude().toString());
    await HomeWidget.saveWidgetData('current_lat', currentPosition?.getLatitude().toString());
    await HomeWidget.saveWidgetData('current_lng', currentPosition?.getLongitude().toString());

    // updating widget's route data
    if (nextRoutes!.isNotEmpty) {
      // first route data
      await HomeWidget.saveWidgetData('first_line_name_0', nextRoutes[0].firstLineName);
      await HomeWidget.saveWidgetData('first_line_color_0', nextRoutes[0].firstLineColor!.value);
      await HomeWidget.saveWidgetData('walking_time_minutes_0', ((nextRoutes[0].walkingTimeMinutes ?? 0) ~/ 60).toString());
      await HomeWidget.saveWidgetData('changes_0', (nextRoutes[0].changes ?? 1 -1).toString());
      await HomeWidget.saveWidgetData('departure_time_0', extractTime(nextRoutes[0].departureTime ?? DateTime.now()));

      // second route data
      await HomeWidget.saveWidgetData('first_line_name_1', nextRoutes[1].firstLineName);
      await HomeWidget.saveWidgetData('first_line_color_1', nextRoutes[1].firstLineColor!.value);
      await HomeWidget.saveWidgetData('walking_time_minutes_1', ((nextRoutes[1].walkingTimeMinutes ?? 0) ~/ 60).toString());  
      await HomeWidget.saveWidgetData('changes_1', (nextRoutes[1].changes ?? 1 -1).toString());
      await HomeWidget.saveWidgetData('departure_time_1', extractTime(nextRoutes[1].departureTime ?? DateTime.now()));

      // third route data
      await HomeWidget.saveWidgetData('first_line_name_2', nextRoutes[2].firstLineName);
      await HomeWidget.saveWidgetData('first_line_color_2', nextRoutes[2].firstLineColor!.value);
      await HomeWidget.saveWidgetData('walking_time_minutes_2', ((nextRoutes[2].walkingTimeMinutes ?? 0) ~/ 60).toString());
      await HomeWidget.saveWidgetData('changes_2', (nextRoutes[2].changes ?? 1 -1).toString());
      await HomeWidget.saveWidgetData('departure_time_2', extractTime(nextRoutes[2].departureTime ?? DateTime.now()));
    }

    await HomeWidget.updateWidget(
        iOSName: 'GetHomeIos', androidName: 'GetHomeWidgetProvider');
  }



  /// Method for updating the home_widget. It needs a global key for the size and an optional
  /// list of the next GetHomeRoutes. The method renders the image of the widget first and then
  /// updated it.
  static void updateHomeWidget(
      var globalKey, List<GetHomeRoute>? nextRoutes, bool atHome) async {
    await renderWidget(globalKey, nextRoutes, atHome);
    HomeWidget.updateWidget(
        iOSName: 'GetHomeIos', androidName: 'GetHomeWidgetProvider');
  }

  /// Method for rendering the image of the widget. If the user is at his home location, an
  /// image for this case is displayed. Else, if the nextRoutes are present, they are rendered
  /// to an image but if not, a default image is rendered. Parameters are a global key for the
  /// size, an optional list of the next GetHomeRoutes and a boolean wether or not the user is
  /// currently at his home location.
  static Future<String> renderWidget(
      var globalKey, List<GetHomeRoute>? nextRoutes, bool atHome) async {
    if (globalKey.currentContext != null) {
      // rendering
      var path = await HomeWidget.renderFlutterWidget(
        atHome
            ? const AtHomeImage()
            : (nextRoutes != null && nextRoutes.isNotEmpty
                ? RouteWidget(nextRoutes: nextRoutes)
                : const DefaultImage()),
        // data for storing and rendering the image
        key: 'filename',
        logicalSize: globalKey.currentContext!.size!,
        pixelRatio: MediaQuery.of(globalKey.currentContext!).devicePixelRatio,
      ) as String;
      print('Updating Widget...');
      return path;
    }
    return 'Path not available';
  }
}
