import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gethome/services/current_location_service.dart';
import 'package:gethome/views/route_widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'package:gethome/services/api_service.dart';

class UpdateWidgetService {
  // test method to simply update widget without any parameters (nicht getestet aber sollte funktionieren)
  static Future<void> updateBackgroundWidget() async {
    print(DateTime.now().toIso8601String());
    // list where the next three GetHomeRoutes are saved in
    List<GetHomeRoute>? _nextRoutes;
    // LatLng object that stores the home location once it's available
    LatLng? _homePosition;
    // API key
    const String _apiKey = 'AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw';

    print('started');
    // update home position
    GetHomeLocation? location = await LocalStorageService.loadLocation('Home');
    if (location != null) {
      _homePosition = LatLng(location.getLatitude(), location.getLongitude());
    }
    //_homePosition = LatLng(48.26388, 11.6688246);

    print(
        'getting home location finished $_homePosition.latitude $_homePosition.longitude');

    // update current location
    /*Position? position;
    await LocationService.getCurrentLocation()
        .then((value) => position = value)
        .catchError((error) {
      position = null;
      return Future.value(position);
    });
    */
    var position = LatLng(48.15003, 11.54555);

    print('getting cords finished');

    // making the API call using both the device's location and the home location
    if (position != null && _homePosition != null) {
      // list of coordinates
      List<String> cords = [
        position.latitude.toString(),
        position.longitude.toString(),
        _homePosition.latitude.toString(),
        _homePosition.longitude.toString()
      ];
      List<GetHomeRoute> list = List.empty();
      print('inside if ');
      try {
        // API call
        list = await GoogleAPI.getRoutes(_apiKey, cords);
      } catch (error) {
        print(error);
        print('no connection found (background error)');
      }
      // setting the value of the _nextRoutes list
      _nextRoutes = list;
    }
    print('getting routes finished');
    print("db${_nextRoutes!.length} routes found");
    _nextRoutes!.forEach((element) {
      print(element.firstLineDepartureLocationName);
    });

    // render image
    var path = await HomeWidget.renderFlutterWidget(
      _nextRoutes != null && _nextRoutes!.isNotEmpty
          ? // either the RouteWidget of a DefaultImage is rendered
          RouteWidget(nextRoutes: _nextRoutes!)
          : const DefaultImage(),
      // data for storing and rendering the image
      key: 'filename',
      logicalSize: Size(430.0, 230.0),
    ) as String;

    HomeWidget.updateWidget(
        iOSName: 'GetHomeIos', androidName: 'GetHomeWidgetProvider');
    print('ended');
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
