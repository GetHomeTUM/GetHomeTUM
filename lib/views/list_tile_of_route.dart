import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/models/user_settings.dart';
import 'package:gethome/services/user_settings_service.dart';

/// Class of a SizedBox that takes a GetHomeRoute and returns a complete designed
/// SizedBox that displays the route's data.
class RouteListTile extends StatefulWidget {
  // minimal borders of the SizedBox, do not change
  static const height = 60.0;
  static const width = 240.0;
  // route to be displayed
  final GetHomeRoute route;
  // size that sets wether the widget is displayed in a large or small format. see enum Size for more
  final Size size;

  const RouteListTile({super.key, required this.route, this.size = Size.small});

  @override
  State<RouteListTile> createState() => _RouteListTileState();
}

class _RouteListTileState extends State<RouteListTile> {
  String walkingDisplay = '-';

  @override
  void initState() {
    super.initState();
    
    _computeWalkingDisplay();
  }

  /// Method to update the walkingDisplay string depending on the userSettings
  Future<void> _computeWalkingDisplay() async {
    String updatedWalkingDisplay = switch (await UserSettingsService.getUserSetting("WalkingMeasure")) {
      WalkingMeasure.minutes => '${(widget.route.walkingTimeMinutes ?? 0) ~/ 60} min',
      WalkingMeasure.meters =>
        // Calculate either meters or kilometers, depending on the distance
        (widget.route.walkingDistanceMeters ?? 0) < 1000 ?
        '${(widget.route.walkingDistanceMeters ?? 0)} m' :
        '${((widget.route.walkingDistanceMeters ?? 0) / 1000).toStringAsFixed(2)} km'
      ,
      _ => throw "Invalid userSetting",
    };

    setState(() {
      walkingDisplay = updatedWalkingDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RouteListTile.height,
      width: RouteListTile.width,
      child: Padding(
        padding: EdgeInsets.only(left: widget.size == Size.small ? 10.0 : 22.0), //22.0
        child: Row(
          children: [
            // Leading column
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size == Size.small ? 0.0 : 8.0), //8.0
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rectangle with the name of the first line inside
                  Container(
                    width: 40,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.route.firstLineColor ?? Colors.blue, // color of the line in the rectangle
                      borderRadius: BorderRadius.circular(5), // circular corners
                    ),
                    child: Text(
                      widget.route.firstLineName.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: (widget.route.firstLineName??'').length >= 4 ? 14 : 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Title row
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    // Displaying the number of changes
                    if (widget.size == Size.large)
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    Text(
                      '+${(widget.route.changes == null || (widget.route.changes ?? 0) == 0 ? 1 : widget.route.changes!) - 1}',
                      style: const TextStyle(fontSize: 14, color: Colors.black), // Kleinerer Text für changes
                    ),

                    // Empty space for separation
                    SizedBox(width: widget.size == Size.small ? 8 : 12),//8

                    // Displaying the departure time of the first line
                    Text(
                      extractTime(widget.route.departureTime ?? DateTime.now()),
                      style: const TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // Trailing row
            Padding(
              padding: EdgeInsets.only(right: widget.size == Size.small ? 10.0 : 40.0), //40.0
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Displaying a walking person icon
                  const Icon(Icons.directions_walk),
                  SizedBox(width: widget.size == Size.small ? 2 : 7),
                  Text(
                    // Display the walking time or distance dynamically
                    walkingDisplay,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

/// Enum for displaying the Tile in a small or a big format. The small format is meant for
/// the widget and the large format is meant for the in-app view.
enum Size { small , large }

/// Additional method to convert a DateTime to a String that consists only of hours
/// and minutes.
String extractTime(DateTime dateTime) {
  // convert DateTime to a String
  String dateTimeString = dateTime.toLocal().toString();
  // extract only the time
  String timeString = dateTimeString.split(' ')[1];
  // extract only the hours and minutes, then return
  return '${timeString.split(':')[0]}:${timeString.split(':')[1]}';
}