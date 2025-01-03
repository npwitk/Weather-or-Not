//
//  City.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 02/01/2025.
//

import CoreLocation
import Foundation

struct City: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static var cities: [City] {
        [
            .init(name: "Bangkok", latitude: 14.077604, longitude: 100.595848),
            .init(name: "Paris, France", latitude: 48.856788, longitude: 2.351077),
            .init(name: "Syndney, Australia", latitude: -33.872710, longitude: 151.205694),
            .init(name: "Washington, DC", latitude: 38.895438, longitude: -77.031281)
        ]
    }
    
    static var mockCurrent: City {
        .init(name: "Bangkok", latitude: 14.077604, longitude: 100.595848)
    }
}
