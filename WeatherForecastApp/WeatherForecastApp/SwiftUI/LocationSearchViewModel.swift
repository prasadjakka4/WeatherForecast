//
//  LocationSearchViewModel.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
import MapKit
class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText = ""
    @Published var locationResult: [MKLocalSearchCompletion] = []
    
    let completer = MKLocalSearchCompleter()
    var completionHandler : ((String) -> Void)?
    var selectedCity: String = ""
    override init() {
        super.init()
        completer.delegate = self
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationResult = completer.results
        locationResult = locationResult.filter{$0.subtitle.lowercased().contains(AppStrings.COUNTRY_NAME_US)}
        self.locationResult = self.locationResult.filter { result in
            if !result.title.contains(",") {
                return false
            }
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            return true
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func dismiss() {
        guard let cityName = selectedCity.components(separatedBy: ",").first else {
            return
        }
        completionHandler?(cityName)
    }
}
