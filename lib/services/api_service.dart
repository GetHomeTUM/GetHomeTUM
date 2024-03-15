import 'package:gethome/models/get_home_route.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAPI {
  //Attribute
  static String curr_latitude = "48.2655045";
  static String curr_longitude = "11.6717073";
  static String home_latitude = "48.1374";
  static String home_longitude = "11.5754";
  //interne Attribute
  static int time = DateTime.now().millisecondsSinceEpoch ~/ 1000; //für Google API time als Sekunden nach 1970
  static String uri = 'https://maps.googleapis.com/maps/api/directions/json?departure_time=$time&destination=$home_latitude,$home_longitude&origin=$curr_latitude,$curr_longitude&mode=transit&key=AIzaSyDQQTxn6Aak4y1HQcKzJ6svMoMLIvAV_rg';
  static String output = ''; //hier steht dann der json-String -> stringToJsonMap(output) benutzen zum Decoden


  //Returned ein Future, das gefragte liste zurückgibt -> "await getRoutes()" zum Abfragen benutzen
  static Future<List<GetHomeRoute>> getRoutes() async {
    List<GetHomeRoute> routes = [];

    //calls der nächsten drei Routen
    for (int i = 0; i < 3; i++) {
      //API call
      await getResponse(fetchAlbum());
      Map<String, dynamic> map = stringToJsonMap(output);

      //Test für Error
      if (output != '-Error-') {
        //Erstellen einer neuen GetHomeRoute
        GetHomeRoute simpleRoute = GetHomeRoute.fromJson(map);
        routes.add(simpleRoute);
        //früheste Startzeit der nächsten Verbindung setzen
        int timeDiff = simpleRoute.departureTime.millisecondsSinceEpoch ~/ 1000 - time;
        time += timeDiff +1;
      }
      
    }

    //Zeit Zurücksetzen für weitere calls
    time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    return routes;
  }

  //Hilfsmethode -> stringToJsonMap(ouput) aufrufen
  static Map<String, dynamic> stringToJsonMap(String s) {
    Map<String, dynamic> jsonMap = jsonDecode(s);
    return jsonMap;
  }

  //Methoden, um von URL zu fetchen
  static void refreshUri() {
    uri = 'https://maps.googleapis.com/maps/api/directions/json?departure_time=$time&destination=$home_latitude,$home_longitude&origin=$curr_latitude,$curr_longitude&mode=transit&key=AIzaSyDQQTxn6Aak4y1HQcKzJ6svMoMLIvAV_rg';
  }
  static Future<http.Response> fetchAlbum() {
    refreshUri();
    return http.get(Uri.parse(uri));
  }
  static Future<void> getResponse(Future<http.Response> future) async {
    var response = await future;
    if (response.statusCode == 200) {
      output = response.body;
    } else {
      output = '-Error-';
    }
  }
}


void main() async {
  List<GetHomeRoute> list = await GoogleAPI.getRoutes();
  print(list[0]);
  print(list[1]);
  print(list[2]);
}