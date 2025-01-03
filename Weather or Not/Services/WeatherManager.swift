//
//  WeatherManager.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 02/01/2025.
//

import CoreLocation
import Foundation
import WeatherKit



class WeatherManager {
    static let shared = WeatherManager()
    let service = WeatherService()
    
    var temperatureFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }
    
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forecast = try? await self.service.weather(
                for: location,
                including: .current
            )
            return forecast
        }.value
        return currentWeather
    }
    
    func hourlyForecast(for location: CLLocation) async -> Forecast<HourWeather>? {
        let hourlyForecast = await Task.detached(priority: .userInitiated) {
            let forecast = try? await self.service.weather(
                for: location,
                including: .hourly
            )
            return forecast
        }.value
        return hourlyForecast
    }
    
    func weatherAttribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attribution
    }
}
