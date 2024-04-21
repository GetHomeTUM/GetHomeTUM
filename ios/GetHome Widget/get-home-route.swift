//
//  get-home-route.swift
//  Runner
//
//  Created by Lennart Hesse on 20.04.24.
//

import Foundation
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
        let startLocation = GetHomeLocation.fromJson(data: legs.first?["start_location"] as? [String: Any])
        let endLocation = GetHomeLocation.fromJson(data: legs.first?["end_location"] as? [String: Any])
        let durationMinutes = computeDuration(data: data)

        return GetHomeRoute(departureTime: departureTime, walkingTimeMinutes: walkingTimeMinutes, walkingDistanceKm: walkingDistanceKm, changes: changes, firstLineName: firstLine?["NameOfFirstLine"], firstLineType: firstLine?["TypeOfFirstLine"], firstLineColor: firstLineColor, firstLineDepartureLocationName: firstLineDepartureLocationName, startLocation: startLocation, endLocation: endLocation, durationMinutes: durationMinutes)
    }
    
    static func saveToUserDefaults(index: String) {
        let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
        userDefaults?.set(firstLineName, forKey: "first_line_name_\(index)")
        userDefaults?.string(firstLineColor, forKey: "first_line_color_\(index)")
        serDefaults?.string(walkingTimeMinutes, forKey: "walking_time_minutes_\(index)")
        userDefaults?.string("\(changes-1)", forKey: "changes_0")
        userDefaults?.string("\( extractTime(from: departureTime))", forKey: "departure_time_0")
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
                return durationValue
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
}

struct GetHomeLocation {
    // Implement GetHomeLocation structure here if needed
}
