//
//  EndPoint.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
/// `EndPoint` defines base URL, all paths and queries.
enum EndPoint: Hashable {
    case baseURL
    case appId
    case todayForecast
    case latitude
    case longitude
    case query
}

extension EndPoint {
    var rawValue: String {
        switch self {
        case .baseURL:
            return "http://api.openweathermap.org/data/2.5/"
        case .appId:
            return "appid"
        case .todayForecast:
            return "weather"
        case .latitude:
            return "lat"
        case .longitude:
            return "lon"
        case .query:
            return "q"
        }
    }
}
