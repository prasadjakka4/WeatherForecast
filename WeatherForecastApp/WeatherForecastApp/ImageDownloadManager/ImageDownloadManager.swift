//
//  ImageDownloadManager.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import UIKit
import Combine

class ImageDownloader {
    var imageCache: NSCache<AnyObject, AnyObject>?
        static let shared = ImageDownloader()
    private init() {
        imageCache = NSCache<AnyObject, AnyObject>()
    }
    func downloadImage(url: String) -> AnyPublisher<UIImage,Error> {
        guard let imageUrl = URL(string: url) else{
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        if let imageFromCache = imageCache?.object(forKey: url as AnyObject) as? UIImage  {
            return Just(imageFromCache).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: imageUrl).tryMap { data, response in
            guard let apiResponse = response as? HTTPURLResponse,
                  apiResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            guard let image = UIImage(data: data) else {
                throw URLError(.badServerResponse)
            }
            self.imageCache?.setObject(image, forKey: url as AnyObject)
            return image
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
