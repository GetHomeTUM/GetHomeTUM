import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/user_settings_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAPIService {

  static String _apiKey = "";

  /// getRoutes(String, List<String>) gibt ein Future zurück, dass eine Liste aus den drei nächsten Verbindungen ausgibt
  /// Um das Output des Futures benutzen zu können, muss "await getRoutes()" benutzt werden!!
  /// Falls eine Route fehlerhaft vorhanden ist, so wird diese auch aufgenommen
  /// Falls für eine fehlerhafte Route keine Startzeit existiert, so wird der nächste Call für die gleiche Zeit durchgeführt
  /// Parameter: start und end location der Route als GetHomeLocation
  static Future<List<GetHomeRoute>> getRoutes({required GetHomeLocation start, required GetHomeLocation end}) async {
    List<GetHomeRoute> routes = [];
    DateTime time = DateTime.now();

    //calls der nächsten drei Routen
    for (int i = 0; i < 3; i++) {
      // Fetch the API key from the storage if not done yet
      if(_apiKey == "") {
        _apiKey = await UserSettingsService.getAPIKey();
      }

      //URL für den API call
      Uri url = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: '/maps/api/directions/json',
        queryParameters: {
          'origin': '${start.getLatitude()},${start.getLongitude()}',
          'destination': '${end.getLatitude()},${end.getLongitude()}',
          'mode': 'transit',
          'departure_time': (time.add(const Duration(seconds: 60)).millisecondsSinceEpoch ~/ 1000).toString(),
          'key': _apiKey
        }
      );

      // execute the API call
      http.Response response = await http.get(url);

      // check if the response is valid
      if (response.statusCode != 200) {
        throw "API call failed with response code ${response.statusCode}";
      }

      // Extract the JSON data from the response
      String routeJsonData = response.body;

      // Umwandlung des JSON Strings in eine Map
      Map<String, dynamic> map = jsonDecode(routeJsonData);

      // Erstellen einer neuen GetHomeRoute
      GetHomeRoute nextRoute = GetHomeRoute.fromJson(map);
      routes.add(nextRoute);

      // time auf den Zeitpunkt nach der ermittelten Route setzen
      // Abfrage, ob Verbindung zulässig ist
      if (map['routes'] != null && map['routes'][0]['legs'] != null) {
        // tatsächliche Startzeit der Verbindung ermittlen (wurde nicht in GetHomeRoute ermittelt)
        var startTime = map['routes'][0]['legs'][0]['departure_time']['value'];
        //früheste Startzeit der nächsten Verbindung setzen
        int timeDiff = startTime - (time.millisecondsSinceEpoch ~/ 1000);
        time = time.add(Duration(seconds: timeDiff+1));
      }
    }

    return routes;
  }
}