class GetHomeRoute {
  DateTime departureTime;
  num walkingTimeMinutes;
  num changes;
  String firstLine;
  String typeOfFirstLine;
  String locationOfFirstDeparture;

  GetHomeRoute({required this.departureTime, required this.walkingTimeMinutes, required this.changes, required this.firstLine, required this.typeOfFirstLine, required this.locationOfFirstDeparture});

  factory GetHomeRoute.fromJson(Map<String, dynamic> data) {

    //Die Abfahrtszeit wird als Unixtimestamp in eine DateTime übeführt
    DateTime departureTime = DateTime.fromMillisecondsSinceEpoch(data['routes'][0]['legs'][0]['steps'][1]['transit_details']['departure_time']['value'] * 1000);

    //Zeit die gelaufen werden muss, um zur ersten Haltestelle zu gelangen wird nur berechnet, wenn der erste Schritt zu Fuß erfolgt
    num walkingTimeMinutes = 0;
    if(data['routes'][0]['legs'][0]['steps'][0]['travel_mode'] == 'WALKING'){
      walkingTimeMinutes = (data['routes'][0]['legs'][0]['steps'][0]['duration']['value'] / 60).round();
    }

    //Die Anzahl der Verbindungen besteht nur aus Transits nicht aus Walking Verbindungen
    int transitSteps = 0;
    for (var step in data['routes'][0]['legs'][0]['steps']) {
      if(step['travel_mode'] == "TRANSIT") {
        transitSteps++;
      }
    }

    //Die erste (die auch angezigt wird) Linie
    String firstLine = '';
    String typeOfFirstLine = '';
    String locationOfFirstDeparture = '';
    for (var step in data['routes'][0]['legs'][0]['steps']) {
      if(step['travel_mode'] == "TRANSIT") {
        //Name der Ersten Linie
        firstLine = step['transit_details']['line']['short_name'];
        //Typ der ersten Linie
        typeOfFirstLine = step['transit_details']['line']['vehicle']['type'];
        //Abfahrtsort der ersten Linie
        locationOfFirstDeparture = step['transit_details']['headsign'];
        break;
      }
    }

    return GetHomeRoute(departureTime: departureTime, walkingTimeMinutes: walkingTimeMinutes, changes: transitSteps, firstLine: firstLine, typeOfFirstLine: typeOfFirstLine, locationOfFirstDeparture: locationOfFirstDeparture);
  }


  @override
  String toString() {
    return '\n departure_time = $departureTime \n walking_time = $walkingTimeMinutes \n changes = $changes \n firstLine = $firstLine \n type = $typeOfFirstLine \n departureLocation = $locationOfFirstDeparture \n';
  }

}
