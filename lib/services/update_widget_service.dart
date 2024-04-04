import 'package:flutter/material.dart';
import 'package:gethome/views/route_widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/models/get_home_route.dart';

class UpdateWidgetService {
  /// Method for updating the home_widget. It needs a global key for the size and an optional
  /// list of the next GetHomeRoutes. The method renders the image of the widget first and then
  /// updated it.
  static void updateHomeWidget(
      var globalKey, List<GetHomeRoute>? nextRoutes) async {
    await renderWidget(globalKey, nextRoutes);
    HomeWidget.updateWidget(
        iOSName: 'GetHomeIos', androidName: 'GetHomeWidgetProvider');
  }

  /// Method for rendering the image of the widget. If the nextRoutes are present, the data will be
  /// rendered to an image that fits on the widget. If the nextRoutes are not present, a default
  /// screen will be rendered. Parameters are a global key for the size and an optional list of the
  /// next GetHomeRoutes
  static Future<String> renderWidget(
      var globalKey, List<GetHomeRoute>? nextRoutes) async {
    if (globalKey.currentContext != null) {
      // rendering
      var path = await HomeWidget.renderFlutterWidget(
        nextRoutes != null && nextRoutes.isNotEmpty
            ? // either the RouteWidget of a DefaultImage is rendered
            RouteWidget(nextRoutes: nextRoutes)
            : const DefaultImage(),
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
