//
//  ContentView.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 02/01/2025.
//

// 13.753253, 100.501641

import CoreLocation
import SwiftUI
import WeatherKit

struct ForecastView: View {
    
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                Text("Fetching Weather...")
            } else {
                if let currentWeather {
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                    Image(systemName: currentWeather.symbolName)
                        .renderingMode(.original)
                        .symbolVariant(.fill)
                        .font(.system(size: 60.0, weight: .bold))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary.opacity(0.2))
                            )
                    
                    let temp = weatherManager.temperatureFormater.string(from: currentWeather.temperature)
                    
                    Text(temp)
                        .font(.title2)
                    
                    Text(currentWeather.condition.description)
                        .font(.title3)
                }
            }
        }
        .padding()
        .task {
            isLoading = true
            Task.detached { @MainActor in
                currentWeather = await weatherManager.currentWeather(for: CLLocation(latitude: 13.753253, longitude: 100.501641))
            }
            isLoading = false
        }
    }
}

#Preview {
    ForecastView()
}
