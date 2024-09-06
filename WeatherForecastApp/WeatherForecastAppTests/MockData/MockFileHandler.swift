//
//  MockFileHandler.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
class MockFilehandler {
    static func readDataFromFile<T: Codable>(at filePath: String) -> T {
        let bundle = Bundle(for: MockFilehandler.self)
        guard let path = bundle.path(forResource: filePath, ofType: "json") else {
            fatalError("FileLoader.readDataFromFile(at \(filePath): file not found path.")
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("FileLoader.readDataFromFile(at \(filePath): Convetion to Data Failed.")
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            fatalError("FileLoader.readDataFromFile(at \(filePath): JSON Parse Error")
        }
    }
}
