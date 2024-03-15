# gethome

##Dokumentation GoogleAPI-Klasse (api_service.dart)
Wichtige Attribute und Funktionen mit *...* gekennzeichnet

Attribute:
*home_latitude* und *home_longitude* -> Koordinaten des Zielorts (Zuhause)
*curr_latitude* und *curr_longitude* -> Koordinaten des aktuellen Orts
time -> Zeit in Sekunden nach 1970 (Google Convention), mit der dann der API-call gemacht wird (normalerweise die aktuelle Zeit)
uri -> URI, in der die Parameter schon eingesetzt sind
output -> nach API-call steht dort der json String

Funktionen:
*Future<List<GetHomeRoute>>: getRoutes()* -> macht API-call und gibt Liste mit drei nächsten Routen zurück. Wichtig bei Futures: immer Aufruf mit "await getRoutes()", anders ist es nicht möglich. Einzige wichtige Funktion.

Map<String, dynamic>: stringToJsonMap(String) -> wandelt String in Json-Map um
void: refreshUri() -> aktualisiert die URI mit den aktuellen Attributen
Future<http.Response>: fetchAlbum() -> gibt die Antwort der API aus
Future<void>: getResponse() -> verarbeitet die Antwort des API-calls und speichert diese in "output"
API-call möglich mit "await getResponse(fetchAlbum())". Danach steht der Json-String in "output".