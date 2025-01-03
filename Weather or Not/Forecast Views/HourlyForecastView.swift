//
//  HourlyForecastView.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 03/01/2025.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    let weatherManager = WeatherManager.shared
    let hourlyForecast: Forecast<HourWeather>
    let timezone: TimeZone
    
    var body: some View {
        Text("Hourly Forecast").font(.title)
        Text("Next 25 hours").font(.caption)
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(hourlyForecast, id: \.date) { hour in
                    VStack(spacing: 0) {
                        Text(hour.date.localTime(for: timezone))
                        Divider()
                        Spacer()
                        Image(systemName: hour.symbolName)
                            .renderingMode(.original)
                            .symbolVariant(.fill)
                            .font(.system(size: 22))
                            .padding(.bottom, 3)
                        if hour.precipitationChance > 0 {
                            Text("\((hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                .foregroundStyle(.cyan)
                                .bold()
                           
                        }
                        Spacer()
                        Text(weatherManager.temperatureFormatter.string(from: hour.temperature))
                    }
                }
            }
            .font(.system(size: 13))
            .frame(height: 100)
        }
        .contentMargins(.all, 15, for: .scrollContent)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondary.opacity(0.2))
            )
    }
}
