//
//  DataStore.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 03/01/2025.
//

import Foundation

@Observable
class DataStore {
    var forPreviews: Bool
    var cities: [City] = []
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            
        }
    }
}
