import UIKit

struct GetHomeRoute {
    var departureTime: Date?
    var walkingTimeMinutes: NSNumber?
    var walkingDistanceKm: NSNumber?
    var changes: NSNumber?
    var firstLineName: String?
    var firstLineType: String?
    var firstLineColor: UIColor?
    var firstLineDepartureLocationName: String?
    var startLocation: GetHomeLocation?
    var endLocation: GetHomeLocation?
    var durationMinutes: NSNumber?

    init(departureTime: Date?, walkingTimeMinutes: NSNumber?, walkingDistanceKm: NSNumber?, changes: NSNumber?, firstLineName: String?, firstLineType: String?, firstLineColor: UIColor?, firstLineDepartureLocationName: String?, startLocation: GetHomeLocation?, endLocation: GetHomeLocation?, durationMinutes: NSNumber?) {
        self.departureTime = departureTime
        self.walkingTimeMinutes = walkingTimeMinutes
        self.walkingDistanceKm = walkingDistanceKm
        self.changes = changes
        self.firstLineName = firstLineName
        self.firstLineType = firstLineType
        self.firstLineColor = firstLineColor
        self.firstLineDepartureLocationName = firstLineDepartureLocationName
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.durationMinutes = durationMinutes
    }

    static func fromJson(data: [String: Any]) -> GetHomeRoute? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]], let steps = legs.first?["steps"] as? [[String: Any]] else {
            return nil
        }

        let departureTime = computeDepartureTime(data: data)
        let walkingTimeMinutes = computeWalkingTime(data: data)
        let walkingDistanceKm = computeWalkingDistance(data: data)
        let changes = computeTransitSteps(data: data)
        let firstLine = computeFirstLine(data: data)
        let firstLineColor = computeFirstLineColor(data: data)
        let firstLineDepartureLocationName = firstLine?["LocationOfFirstDeparture"]
        let startLocation = GetHomeLocation.fromJson(json: legs.first?["start_location"] as? [String: Any] ?? ["null":"null"])
        let endLocation = GetHomeLocation.fromJson(json: legs.first?["end_location"] as? [String: Any] ?? ["null":"null"])
        let durationMinutes = computeDuration(data: data)

        return GetHomeRoute(departureTime: departureTime, walkingTimeMinutes: walkingTimeMinutes, walkingDistanceKm: walkingDistanceKm, changes: changes, firstLineName: firstLine?["NameOfFirstLine"], firstLineType: firstLine?["TypeOfFirstLine"], firstLineColor: firstLineColor, firstLineDepartureLocationName: firstLineDepartureLocationName, startLocation: startLocation, endLocation: endLocation, durationMinutes: durationMinutes)
    }
    
    func saveToUserDefaults(index: Int) {
        let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
        userDefaults?.set(firstLineName ?? "null", forKey: "first_line_name_\(index)")
        print("first_line_name_\(index): \(firstLineName ?? "U22")")
        userDefaults?.set("\(firstLineColor!.toInt() ?? 235733)", forKey: "first_line_color_\(index)")
        print("first_line_color_\(index): \(firstLineColor!.toInt() ?? 235733)")
        userDefaults?.set("\((walkingTimeMinutes ?? 0))", forKey: "walking_time_minutes_\(index)")
        print("walking_time_minutes_\(index): \((walkingTimeMinutes ?? 0))")
        userDefaults?.set("\(changes as! Int-1)", forKey: "changes_\(index)")
        print("changes_\(index): \(changes as! Int-1)")
        userDefaults?.set("\(extractTime(from: departureTime ?? Date()))", forKey: "departure_time_\(index)")
        print("departure_time_\(index): \(extractTime(from: departureTime ?? Date()))")
    }

    static func computeDepartureTime(data: [String: Any]) -> Date? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "TRANSIT", let transitDetails = step["transit_details"] as? [String: Any], let departureTimeDict = transitDetails["departure_time"] as? [String: Any], let departureTimeValue = departureTimeDict["value"] as? Int64 {
                return Date(timeIntervalSince1970: TimeInterval(departureTimeValue))
            }
        }
        return nil
    }

    static func computeWalkingTime(data: [String: Any]) -> NSNumber? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "WALKING", let duration = step["duration"] as? [String: Any], let durationValue = duration["value"] as? NSNumber {
                return NSNumber(value: round(durationValue.doubleValue / 60))
            }
        }
        return nil
    }

    static func computeWalkingDistance(data: [String: Any]) -> NSNumber? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "WALKING", let distance = step["distance"] as? [String: Any], let distanceValue = distance["value"] as? NSNumber {
                return distanceValue
            }
        }
        return nil
    }

    static func computeTransitSteps(data: [String: Any]) -> NSNumber? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        var transitSteps: NSNumber = 0
        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "TRANSIT" {
                transitSteps = NSNumber(value: transitSteps.intValue + 1)
            }
        }
        return transitSteps
    }

    static func computeFirstLine(data: [String: Any]) -> [String: String]? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "TRANSIT", let transitDetails = step["transit_details"] as? [String: Any], let line = transitDetails["line"] as? [String: Any], let shortName = line["short_name"] as? String, let vehicle = line["vehicle"] as? [String: Any], let type = vehicle["type"] as? String, let headsign = transitDetails["headsign"] as? String {
                return ["NameOfFirstLine": shortName, "TypeOfFirstLine": type, "LocationOfFirstDeparture": headsign]
            }
        }
        return nil
    }

    static func computeFirstLineColor(data: [String: Any]) -> UIColor? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        for step in legs.first?["steps"] as? [[String: Any]] ?? [] {
            if let travelMode = step["travel_mode"] as? String, travelMode == "TRANSIT", let transitDetails = step["transit_details"] as? [String: Any], let line = transitDetails["line"] as? [String: Any], let color = line["color"] as? String {
                let alphaHex = 0xFF000000
                if let rgbHex = Int(color.dropFirst(), radix: 16) {
                    return UIColor(red: CGFloat((alphaHex + rgbHex) >> 16 & 0xFF) / 255.0, green: CGFloat((alphaHex + rgbHex) >> 8 & 0xFF) / 255.0, blue: CGFloat((alphaHex + rgbHex) & 0xFF) / 255.0, alpha: 1.0)
                }
            }
        }
        return nil
    }

    static func computeDuration(data: [String: Any]) -> NSNumber? {
        guard let routes = data["routes"] as? [[String: Any]], let legs = routes.first?["legs"] as? [[String: Any]] else {
            return nil
        }

        if let duration = legs.first?["duration"] as? [String: Any], let durationValue = duration["value"] as? NSNumber {
            return durationValue
        }
        return nil
    }
    
    func toString() -> String {
        return "startLocation = \(startLocation ?? GetHomeLocation(lat: 0.0, lng: 0.0))\nendLocation = \(endLocation ?? GetHomeLocation(lat: 0.0, lng: 0.0))\ndeparture_time = \(departureTime ?? Date())\nwalking_time = \(walkingTimeMinutes ?? NSNumber())\nwalking_distance = \(walkingDistanceKm ?? NSNumber())\nchanges = \(changes ?? NSNumber())\nfirstLine = \(firstLineName ?? "N/A")\nfirstLineType = \(firstLineType ?? "N/A")\nfirstLineColor = \(firstLineColor != nil ? String(describing: firstLineColor!.toInt()) : "N/A")\nfirstLineDepartureLocation = \(firstLineDepartureLocationName ?? "N/A")\nduration = \(durationMinutes ?? NSNumber())"
            
        }
}
extension UIColor {
    func toInt() -> Int? {
        guard let components = self.cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)

        // Combine RGB components into a single integer
        return (r << 16) + (g << 8) + b
    }
}


struct GetHomeLocation {
    let lat: Double
    let lng: Double

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }

    static func fromJson(json: [String: Any]) -> GetHomeLocation? {
        guard let lat = json["lat"] as? Double, let lng = json["lng"] as? Double else {
            return nil
        }
        return GetHomeLocation(lat: lat, lng: lng)
    }

    func toJson() -> [String: Any] {
        return ["lat": lat, "lng": lng]
    }

    var latitude: Double {
        return lat
    }

    var longitude: Double {
        return lng
    }

    var description: String {
        return """
        GetHomeLocation:
        Latitude: \(lat)
        Longitude: \(lng)
        """
    }
}


func getDirections(apiKey: String, originLat: String, originLng: String, destLat: String, destLng: String, date: Date, completion: @escaping (Result<String, Error>) -> Void) {
    let unixTimeStamp = Int(round(date.timeIntervalSince1970))
    // Konstruieren der URL mit den gegebenen Parametern
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?destination=\(destLat),\(destLng)&origin=\(originLat),\(originLng)&departure_time=\(unixTimeStamp)&mode=transit&key=\(apiKey)"
    
    // Erstellen einer URL-Instanz aus der URL-String
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }
    
    // Erstellen eines URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Erstellen einer URLSession
    let session = URLSession.shared
    
    // Erstellen einer Datenaufgabe für die Anforderung
    let task = session.dataTask(with: request) { data, response, error in
        // Überprüfen auf Fehler
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Überprüfen auf Daten
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
            return
        }
        
        // Konvertieren der Daten in einen String
        if let responseString = String(data: data, encoding: .utf8) {
            completion(.success(responseString))
        } else {
            completion(.failure(NSError(domain: "Failed to convert data to string", code: 2, userInfo: nil)))
        }
    }
    
    // Starten der Aufgabe
    task.resume()
}

enum APIError: Error {
    case invalidResponse
    case requestFailed
    case invalidData // Neuer Fall für ungültige Daten
}

func extractTime(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm" // Setze das gewünschte Format für die Uhrzeit
    
    return dateFormatter.string(from: date) // Extrahiere die Uhrzeit im gewünschten Format
}

func getRoutes(apiKey: String, originLat: String, originLng: String, destLat: String, destLng: String, completion: @escaping (Result<[GetHomeRoute], APIError>) -> Void) {
    var routes: [GetHomeRoute] = []
    var time: Date = Date()
    let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")

    // Hilfsfunktion, um die API-Aufrufe rekursiv nacheinander auszuführen
    func getNextRoute(index: Int) {
        // Überprüfe, ob alle Routen abgerufen wurden
        guard index < 3 else {
            userDefaults?.set(extractTime(from: Date()), forKey: "time")
            completion(.success(routes))
            return
        }

        // API-Aufruf für die nächste Route
        getDirections(apiKey: apiKey, originLat: originLat, originLng: originLng, destLat: destLat, destLng: destLng, date: time) { result in
            switch result {
            case .success(let output):
                guard let map = stringToJsonMap(output) else {
                    completion(.failure(.invalidData))
                    return
                }
                
                // Zeit auf den Zeitpunkt nach der ermittelten Route setzen
                // Abfrage, ob Verbindung zulässig ist
                if let routesData = map["routes"] as? [[String: Any]], !routesData.isEmpty {
                    if let legs = routesData[0]["legs"] as? [[String: Any]], !legs.isEmpty,
                       let departureTime = legs[0]["departure_time"] as? [String: Any],
                       let startTime = departureTime["value"] as? TimeInterval {
                        userDefaults?.set(Date(), forKey: "time")
                        userDefaults?.set("success", forKey: "api_check")
                        let route = GetHomeRoute.fromJson(data: map)
                        routes.append(route!)
                        // Tatsächliche Startzeit der Verbindung ermitteln (wurde nicht in GetHomeRoute ermittelt)
                        time = Date(timeIntervalSince1970: (startTime + 1))
                    }
                }

                // Rufe den nächsten API-Aufruf rekursiv auf
                getNextRoute(index: index + 1)

            case .failure(let error):
                userDefaults?.set("\(error)", forKey: "api_check")
                // Bei einem Fehler, rufe die Completion mit dem Fehler auf
                completion(.failure(.requestFailed))
            }
        }
    }

    // Starte den rekursiven Prozess mit dem ersten API-Aufruf
    getNextRoute(index: 0)
}

func stringToJsonMap(_ jsonString: String) -> [String: Any]? {
    guard let data = jsonString.data(using: .utf8) else {
        return nil
    }

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        }
    } catch {
        print("Error parsing JSON: \(error)")
    }

    return nil
}



func main() {
    let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
    let apiKey = "AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw"
    userDefaults?.set("48.16873234456", forKey: "current_lat")
    userDefaults?.set("11.56530037522", forKey: "current_lng")
    let originLat = userDefaults?.string(forKey: "current_lat") ?? "48.15003"
    let originLng = userDefaults?.string(forKey: "current_lng") ?? "11.54555"
    print("\(originLat),\(originLng)")
    let destLat = userDefaults?.string(forKey: "home_lat") ?? "48.265755"
    let destLng = userDefaults?.string(forKey: "home_lng") ?? "11.666527"
    print("\(destLat),\(destLng)")

    getRoutes(apiKey: apiKey, originLat: originLat, originLng: originLng, destLat: destLat, destLng: destLng) { result in
        switch result {
        case .success(let responseString):
            responseString[0].saveToUserDefaults(index: 0)
            responseString[1].saveToUserDefaults(index: 1)
            responseString[2].saveToUserDefaults(index: 2)
            print("Route1: \(responseString[0].toString())\nRoute2: \(responseString[1].toString())\nRoute3: \(responseString[2].toString())")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}

main()
