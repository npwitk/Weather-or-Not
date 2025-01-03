//
//  ForecastView.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 02/01/2025.
//

// 13.753253, 100.501641

import CoreLocation
import SwiftUI
import WeatherKit

struct ForecastView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(LocationManager.self) var locationManager
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    
    @State private var currentWeather: CurrentWeather?
    @State private var hourlyForecast: Forecast<HourWeather>?
    
    @State private var isLoading = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
    var highTemperature: String? {
        if let high = hourlyForecast?.map({ $0.temperature }).max() {
            return weatherManager.temperatureFormatter.string(from: high)
        } else {
            return nil
        }
    }
    
    var lowTemperature: String? {
        if let low = hourlyForecast?.map({$0.temperature}).min() {
            return weatherManager.temperatureFormatter.string(from: low)
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack {
            if let selectedCity {
                if isLoading {
                    ProgressView()
                    Text("Fetching Weather...")
                } else {
                    Text(selectedCity.name)
                        .font(.title)
                        .bold()
                    if let currentWeather {
                        CurrentWeatherView(
                            currentWeather: currentWeather,
                            highTemperature: highTemperature,
                            lowTemperature: lowTemperature,
                            timezone: timezone
                        )
                    }
                    Divider()
                    if let hourlyForecast {
                        HourlyForecastView(
                            hourlyForecast: hourlyForecast,
                            timezone: timezone
                        )
                    }
                    Spacer()
                    AttributionView()
                        .tint(.white)
                }
            }
        }
        .padding()
        .background {
            if selectedCity != nil {
                let condition = currentWeather?.condition
                BackgroundView(condition: condition ?? .clear)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showCityList.toggle()
            } label: {
                Image(systemName: "list.star")
            }
            .padding()
            .background(Color(.darkGray))
            .clipShape(.circle)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .fullScreenCover(isPresented: $showCityList) {
            CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                selectedCity = locationManager.currentLocation
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
}
