//
//  CitiesListView.swift
//  Weather or Not
//
//  Created by Nonprawich I. on 03/01/2025.
//

import SwiftUI

struct CitiesListView: View {
    @Environment(\.dismiss) var dismiss
    let currentLocation: City?
    @Binding var selectedCity: City?
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    if let currentLocation {
                        CityRowView(city: currentLocation)
                            .onTapGesture {
                                selectedCity = currentLocation
                                dismiss()
                            }
                    }
                    
                    ForEach(City.cities) { city in
                        CityRowView(city: city)
                            .onTapGesture {
                                selectedCity = city
                                dismiss()
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .listRowInsets(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
        
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
}
