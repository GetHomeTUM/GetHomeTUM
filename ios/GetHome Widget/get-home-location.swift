//
//  get-home-location.swift
//  Runner
//
//  Created by Lennart Hesse on 20.04.24.
//

import Foundation

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
