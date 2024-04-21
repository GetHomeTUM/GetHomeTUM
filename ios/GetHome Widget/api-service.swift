//
//  api-service.swift
//  Runner
//
//  Created by Lennart Hesse on 19.04.24.
//

import Foundation

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


func getRoutes(apiKey: String, originLat: String, originLng: String, destLat: String, destLng: String, completion: @escaping (Result<String, APIError>) -> Void) {
    var msg: String = ""
    var time: Date = Date()
    let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")

    // Hilfsfunktion, um die API-Aufrufe rekursiv nacheinander auszuführen
    func getNextRoute(index: Int) {
        // Überprüfe, ob alle Routen abgerufen wurden
        guard index < 3 else {
            completion(.success(String(time.timeIntervalSince1970)))
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
                if let routes = map["routes"] as? [[String: Any]],
                   !routes.isEmpty,
                   let legs = routes[0]["legs"] as? [[String: Any]],
                   !legs.isEmpty,
                   let departureTime = legs[0]["departure_time"] as? [String: Any],
                   let startTime = departureTime["value"] as? TimeInterval {
                    print(extractTime(from: Date.init(timeIntervalSince1970: startTime)))
                    userDefaults?.set(extractTime(from: Date.init(timeIntervalSince1970: startTime)), forKey: "departure_time_\(index)")
                    userDefaults?.set(extractTime(from: Date()), forKey: "time")
                    userDefaults?.set("success", forKey: "api_check")
                    
                    // Tatsächliche Startzeit der Verbindung ermitteln (wurde nicht in GetHomeRoute ermittelt)
                    time = Date(timeIntervalSince1970: (startTime + 1))
                    msg += String(startTime)
                    
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
    let apiKey = "AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw"
    let originLat = "48.15003"
    let originLng = "11.54555"
    let destLat = "48.265755"
    let destLng = "11.666527"

    getRoutes(apiKey: apiKey, originLat: originLat, originLng: originLng, destLat: destLat, destLng: destLng) { result in
        switch result {
        case .success(let responseString):
            print("Response String: \(responseString)")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}