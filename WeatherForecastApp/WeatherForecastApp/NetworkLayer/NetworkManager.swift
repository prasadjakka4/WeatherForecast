//
//  NetworkManager.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation

/// `APIManager` is an abstract type, used to parse the `Result` data from the server.
struct NetworkManager {}

protocol APIService {
    func fetchWeatherData<T: Codable>(urlRequest: APIRequest, completion: @escaping ((Result<T, NetworkError>) -> Void))
}
    

extension NetworkManager: APIService {
    func fetchWeatherData<T: Codable>(urlRequest: APIRequest, completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        let request = urlRequest.request()
        
        //Create the Session Configuration with default/ephimeral type
        let configuration = URLSessionConfiguration.default
        
        //Set its time-out interval to certain seconds
        configuration.timeoutIntervalForRequest = 30
        
        //Create the session with created configuration
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let apiResponse = response as? HTTPURLResponse,
                  apiResponse.statusCode == 200 else {
                completion(.failure(.server))
                return
            }
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let model = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(model))
            } catch {
                completion(.failure(.jsonParse))
            }
        }
        task.resume()
        
    }

}
