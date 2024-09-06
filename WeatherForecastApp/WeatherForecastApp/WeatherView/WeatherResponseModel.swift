//
//  WeatherResponseModel.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation

struct WeatherResponseModel: Codable, Identifiable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let date: Int?
    let id: Int?
    let name: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case weather
        case base
        case main
        case visibility
        case wind
        case date = "dt"
        case id
        case name
        case message
    }
}

struct Main: Codable {
    let temparature: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let groundLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temparature = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

struct WeatherElement: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
        case icon
    }
}

struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

//MARK: - Formatted Weather
struct WeatherDataModel: Codable {
    var city: String = ""
    var temparature: String = ""
    var condition: String = ""
    var description: String = ""
    var imageURL: String = ""
    var feelsLike: String = ""
    var minMaxTemparature: String = ""
    var rainPercent: String = ""
    var windDirection: String = ""
    var date: String = ""
    var humidity: String = ""
    var windSpeed: String = ""
    var pressure: String = ""
    var isCurrentLocation = false
    
    func createWeatherDataModel(model: WeatherResponseModel) -> WeatherDataModel {
        var weatherFormatted = WeatherDataModel()
        let temparature = "\(Int(model.main?.temparature ?? 0.0)) º"
        var description = ""
        var image = ""

        if let weathers = model.weather, weathers.count > 0 {
            description = weathers[0].weatherDescription ?? ""
            image = weathers[0].icon ?? ""
        }
        if image.isEmpty == false {
            weatherFormatted.imageURL = "https://openweathermap.org/img/wn/" + image + "@2x.png"
        }
        weatherFormatted.city = model.name ?? ""
        weatherFormatted.temparature = temparature
        weatherFormatted.condition = condition
        weatherFormatted.description = description
        weatherFormatted.minMaxTemparature = minMaxTemparature
        weatherFormatted.date = date
        weatherFormatted.humidity = "\(String(describing: model.main?.humidity ?? 0))"
        weatherFormatted.pressure = "\(String(describing: model.main?.pressure ?? 0))"
        weatherFormatted.windSpeed = "\(String(describing: model.wind?.speed ?? 0))"
        return weatherFormatted
    }

}

extension UserDefaults {

    func set<T: Encodable>(codable: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(codable)
            let jsonString = String(data: data, encoding: .utf8)!
            print("Saving \"\(key)\": \(jsonString)")
            self.set(jsonString, forKey: key)
        } catch {
            print("Saving \"\(key)\" failed: \(error)")
        }
    }

    func codable<T: Decodable>(_ codable: T.Type, forKey key: String) -> T? {
        guard let jsonString = self.string(forKey: key) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        print("Loading \"\(key)\": \(jsonString)")
        return try? decoder.decode(codable, from: data)
    }
}
struct WeatherRequest: APIRequest {
   var method: HTTPMethod = .GET
   var path: EndPoint = .todayForecast
   var parameters: [EndPoint : String] = [:]
   var body: [String : Any]? = nil
   var currentLocation: Bool = false
}
