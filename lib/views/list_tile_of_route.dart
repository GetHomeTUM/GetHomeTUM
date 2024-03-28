import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_route.dart';

/// Class of a ListTile that takes a GetHomeRoute and returns a complete designed
/// ListTile that displays the route's data.
class RouteListTile extends StatelessWidget {
  // route to be displayed
  final GetHomeRoute route;

  const RouteListTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // rectangle with the name of the first line inside
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
      title: Row(
        children: [

          // displaying the number of changes
          Icon(Icons.arrow_forward_ios,
          size: 14),
          Text(
            '+${(route.changes == null || route.changes == 0 ? 1 : route.changes!) - 1}',
            style: TextStyle(fontSize: 14), // Kleinerer Text für changes
          ),

          // empty space for separation
          SizedBox(width: 20),

          // displaying the departure time of the first line
          Text(
            extractTime(route.departureTime!),
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          // displaying the walking time and a walking person icon
          Icon(Icons.directions_walk,),
          SizedBox(width: 5),
          Text(
            '${(route.walkingTimeMinutes == null ? 0 : route.walkingTimeMinutes!) ~/ 60} min',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
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