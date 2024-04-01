import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_route.dart';

/// Class of a ListTile that takes a GetHomeRoute and returns a complete designed
/// ListTile that displays the route's data.
class RouteListTile extends StatelessWidget {
  // route to be displayed
  final GetHomeRoute route;

  const RouteListTile({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
  return SizedBox(
    height: 60, // Adjust height as needed
    child: Padding(
      padding: const EdgeInsets.only(left: 0.0), //22.0
    child: Row(
      children: [
        // Leading column
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0), //8.0
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rectangle with the name of the first line inside
              Container(
                width: 40,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (route.color == null ? Colors.blue : Color(route.color!)), // Farbe des Rechtecks
                  borderRadius: BorderRadius.circular(5), // Runden des Rechtecks
                ),
                child: Text(
                  route.firstLine.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
                Icon(Icons.arrow_forward_ios, size: 14),
                Text(
                  '+${(route.changes == null || (route.changes ?? 0) == 0 ? 1 : route.changes!) - 1}',
                  style: TextStyle(fontSize: 14, color: Colors.black), // Kleinerer Text für changes
                ),

                // Empty space for separation
                SizedBox(width: 8),//8

                // Displaying the departure time of the first line
                Text(
                  extractTime(route.departureTime ?? DateTime.now()),
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ],
            ),
          ),
        ),

        // Trailing row
        Padding(
          padding: const EdgeInsets.only(right: 0.0), //40.0
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Displaying the walking time and a walking person icon
              Icon(Icons.directions_walk),
              SizedBox(width: 5),
              Text(
                '${(route.walkingTimeMinutes == null ? 0 : route.walkingTimeMinutes!) ~/ 60} min',
                style: TextStyle(fontSize: 20, color: Colors.black),
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


/// Additional method to convert a DateTime to a String that consists only of hours
/// and minutes.
String extractTime(DateTime dateTime) {
  // Konvertiere DateTime in einen String
  String dateTimeString = dateTime.toLocal().toString();
  
  // Extrahiere nur die Zeit
  String timeString = dateTimeString.split(' ')[1];

  return '${timeString.split(':')[0]}:${timeString.split(':')[1]}';
}