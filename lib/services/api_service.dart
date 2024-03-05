import 'package:gethome/models/get_home_route.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAPI {
  //Attribute
  static String curr_latitude = "48.2655045";
  static String curr_longitude = "11.6717073";
  static String home_latitude = "48.1374";
  static String home_longitude = "11.5754";
  static String uri = 'https://maps.googleapis.com/maps/api/directions/json?destination=$home_latitude,$home_longitude&origin=$curr_latitude,$curr_longitude&mode=transit&key=AIzaSyDQQTxn6Aak4y1HQcKzJ6svMoMLIvAV_rg';
  static String output = ''; //hier steht dann der json-String -> stringToJsonMap(output) benutzen zum Decoden

  //Testmethode
  static void test() async {
    //wichtig bei jeder Abfrage:
    await getResponse(fetchAlbum());
    Map<String, dynamic> map = stringToJsonMap(output);
    
    //test values hier abfragen
    print(map['routes'][0]['legs'][0]['departure_time']['text']);
  }

  //Hilfsmethode -> stringToJsonMap(ouput) aufrufen
  static Map<String, dynamic> stringToJsonMap(String s) {
    Map<String, dynamic> jsonMap = jsonDecode(s);
    return jsonMap;
  }

  //Methoden, um von URL zu fetchen
  static Future<http.Response> fetchAlbum() {
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

  //TODO
  static List<GetHomeRoute> getRoutes() {
    // TODO Make the API calls and return a list of possible routes
    return List.empty();
  }
}


//main
void main() async {

  GoogleAPI.test();

}