import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/views/list_tile_of_route.dart';
import 'package:gethome/models/get_home_route.dart';

/// Method for updating the home_widget. It needs a global key for the size and an optional
/// list of the next GetHomeRoutes. The method renders the image of the widget first and then 
/// updated it.
void updateHomeWidget(var globalKey, List<GetHomeRoute>? nextRoutes) async {
  await renderWidget(globalKey, nextRoutes);
  HomeWidget.updateWidget(
    iOSName: 'GetHomeIos',
    androidName: 'GetHomeAndroid',
  );
}

/// Method for rendering the image of the widget. If the nextRoutes are present, the data will be
/// rendered to an image that fits on the widget. If the nextRoutes are not present, a default 
/// screen will be rendered. Parameters are a global key for the size and an optional list of the
/// next GetHomeRoutes
Future<String> renderWidget(var globalKey, List<GetHomeRoute>? nextRoutes) async {
  if (globalKey.currentContext != null) {
    // rendering
    var path = await HomeWidget.renderFlutterWidget(
      nextRoutes != null && nextRoutes.isNotEmpty ? // either the RouteWidget of a DefaultImage is rendered
      RouteWidget(nextRoutes: nextRoutes)
      :
      const DefaultImage(),
      // data for storing and rendering the image
      key: 'filename',
      logicalSize: globalKey.currentContext!.size!,
      pixelRatio:
        MediaQuery.of(globalKey.currentContext!).devicePixelRatio,
    ) as String;
    print('Updating Widget...');
    return path;
  }
  return 'Path not available';
}

/// Class that returns a fully designed SizedBox of the next first three GetHomeRoutes in the
/// list. The format is designed for the widget.
class RouteWidget extends StatelessWidget {
  final List<GetHomeRoute> nextRoutes;

  const RouteWidget({super.key, required this.nextRoutes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // using the width of the RouteListTile to be a perfect square (necessary for correct rendering)
        height: RouteListTile.width,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // headline that says 'HOME'
            const Text('HOME',
              style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
                ),
            // listing the next three routes
            RouteListTile(route: nextRoutes[0]),
            const SizedBox(height: 8),
            RouteListTile(route: nextRoutes[1]),
            const SizedBox(height: 8),
            RouteListTile(route: nextRoutes[2]),
          ],
        )
      );
  }}

/// Class of the default image the is displayed if the routes are not available. Returns a 
/// SizedBox that simply says 'Connections not available'.
class DefaultImage extends StatelessWidget {
  const DefaultImage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: RouteListTile.width,
      height: RouteListTile.width,
      child: Center(
        child: Text(
          'Connections not available.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}