import 'package:flutter/material.dart';
import 'package:gethome/views/list_tile_of_route.dart';
import 'package:gethome/models/get_home_route.dart';

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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            // listing the next three routes
            RouteListTile(route: nextRoutes[0]),
            const SizedBox(height: 8),
            RouteListTile(route: nextRoutes[1]),
            const SizedBox(height: 8),
            RouteListTile(route: nextRoutes[2]),
          ],
        ));
  }
}

/// Class of the default image that is displayed if the routes are not available. Returns a
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

/// Class of an Image that is displayed if the user is currently at his home location.
class AtHomeImage extends StatelessWidget {
  const AtHomeImage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: RouteListTile.width,
      height: RouteListTile.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are at home.',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text('😴',
              style: TextStyle(fontSize: 30.0)
            ),
          ],
        ),
      );
  }
}
