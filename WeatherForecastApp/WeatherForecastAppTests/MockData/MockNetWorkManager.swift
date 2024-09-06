//
//  MockNetWorkManager.swift
//  WeatherForecastAppTests
//
//  Created by Prasad Jakka on 9/5/24.
//

import XCTest

class MockNetWorkManager<U: Codable>: APIService {
    
    //MARK: - Variables
    var handler:  ((Result<U,NetworkError>) -> Void)!     // ((U?, NetworkError?) -> ())!
    var isDataFetched = false
    var model: U? = nil
    
    //MARK: - Success
    func fetchWithSuccess() {
        guard let result = model else{
            return
        }
        handler(.success(result))
    }
    
    //MARK: - Failure
    func fetchWithError(_ error: NetworkError?) {
        guard let errorResponse = error else{
            return
        }
        handler(.failure(errorResponse))
    }
    
    //MARK: - API
    
    func fetchWeatherData<T: Decodable>(urlRequest: APIRequest, completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        isDataFetched = true
        self.handler = { (result: Result<U, NetworkError>) in
            if let apiResult = result as? Result<T, NetworkError> {
                completion(apiResult)
            }
        }
    }

}

