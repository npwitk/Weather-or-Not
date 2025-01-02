//
//  Weather_or_NotApp.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 02/01/2025.
//

import SwiftUI

@main
struct Weather_or_NotApp: App {
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
    }
}
