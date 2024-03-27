import 'package:gethome/models/get_home_route.dart';
import 'package:gethome/services/api_service_url_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAPI {

  /// getRoutes(String, List<String>) gibt ein Future zurück, dass eine Liste aus den drei nächsten Verbindungen ausgibt
  /// Um das Output des Futures benutzen zu können, muss "await getRoutes()" benutzt werden!!
  /// Falls eine Route fehlerhaft vorhanden ist, so wird diese auch aufgenommen
  /// Falls für eine fehlerhafte Route keine Startzeit existiert, so wird der nächste Call für die gleiche Zeit durchgeführt
  /// Parameter: apiKey,
  /// cords: Liste aus Koordinaten von Start und Ziel im Format [latitudeOrigin, longitudeQrigin, latitudeDestination, longitudeDestination]
  static Future<List<GetHomeRoute>> getRoutes(String apiKey, List<String> cords) async {
    List<GetHomeRoute> routes = [];
    DateTime time = DateTime.now();

    //calls der nächsten drei Routen
    for (int i = 0; i < 3; i++) {
      //API call
      String output = await _getResponse(_fetchAlbum(apiKey, cords, time.add(const Duration(seconds: 60))));
      // Umwandlung des Strings in eine Json-Map
      Map<String, dynamic> map = _stringToJsonMap(output);

      //Erstellen einer neuen GetHomeRoute
      GetHomeRoute simpleRoute = GetHomeRoute.fromJson(map);
      routes.add(simpleRoute);

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



  /// _stringToJsonMap(String) gibt eine Map aus einem Json-String aus
  /// Parameter: s: String im Json-Format
  static Map<String, dynamic> _stringToJsonMap(String s) {
    Map<String, dynamic> jsonMap = jsonDecode(s);
    return jsonMap;
  }

  /// Hilfsmethoden für API-call:
  /// _fetchAlbum(String, String, String, String, DateTime) macht den API-call aus den übergebenen Parametern und gibt ein Future
  /// zurück, welches die http.Response zurückgibt
  /// Parameter:
  /// apiKey,
  /// cords: Liste aus Koordinaten im Format [latitudeOrigin, longitudeQrigin, latitudeDestination, longitudeDestination],
  /// time: Startzeit der Verbindung, für die der API-call gemacht wird
  /// 
  /// _getResponse(Future<http.Response>) wertet eine http.Response aus und gibt ein Future zurück, welches den String der 
  /// Response zurückgibt, falls die http.Response fehlerfrei ausgeführt werden konnte
  /// Falls die http Request fehlerhaft war, wird ein Error geworfen
  /// Parameter: future: Future, welches eine http Request macht und eine http.Response ausgibt
  static Future<http.Response> _fetchAlbum(String apiKey, List<String> cords, DateTime time) {
    print(URLBuilder.buildUri(apiKey, cords, time).toString());
    return http.get(URLBuilder.buildUri(apiKey, cords, time));
  }
  static Future<String> _getResponse(Future<http.Response> future) async {
    var response = await future;
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Error();
    }
  }
}