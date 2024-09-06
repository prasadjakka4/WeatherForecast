//
//  StoryBoardHelper.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import UIKit
protocol StoryBoardHelper {
    static func instantiate() -> Self
}

extension StoryBoardHelper where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("Failed to instantiate view controller with identifier: \(className)")
        }
        return viewController
    }

    private static var className: String {
        return String(describing: self)
    }
    
    private static var storyboardName: String {
        return "Main"
    }
}
