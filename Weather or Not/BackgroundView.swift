//
//  BackgroundView.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 03/01/2025.
//

import SwiftUI
import WeatherKit

struct BackgroundView: View {
    let condition: WeatherCondition
    var body: some View {
        Image(condition.rawValue)
            .blur(radius: 5)
            .colorMultiply(.white.opacity(0.8))
    }
}

#Preview {
    BackgroundView(condition: .cloudy)
}
