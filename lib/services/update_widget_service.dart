import 'package:flutter/material.dart';
import 'package:gethome/views/route_widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/models/get_home_route.dart';

class UpdateWidgetService {
  /// Method for updating the home_widget. It needs a global key for the size, an optional
  /// list of the next GetHomeRoutes and a boolean wether or not the user is currently at his
  /// home location. The method renders the image of the widget first and then updates it.
  static void updateHomeWidget(var globalKey, List<GetHomeRoute>? nextRoutes, bool atHome) async {
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
            : const DefaultImage()
            ),
        // data for storing and rendering the image
        key: 'filename',
        logicalSize: globalKey.currentContext!.size!,
        pixelRatio: MediaQuery.of(globalKey.currentContext!).devicePixelRatio,
      ) as String;
      debugPrint('Updating Widget...');
      return path;
    }
    return 'Path not available';
  }
}
