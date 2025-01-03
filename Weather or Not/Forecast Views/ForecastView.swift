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
    @State private var isLoading = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
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
                        Text(currentWeather.date.localDate(for: timezone))
                        Text(currentWeather.date.localTime(for: timezone))
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
                        
                        Spacer()
                        AttributionView()
                            .tint(.white)
                    }
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
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
}
