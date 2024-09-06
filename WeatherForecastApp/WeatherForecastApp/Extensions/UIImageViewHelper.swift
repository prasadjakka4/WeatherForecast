//
//  UIImageViewHelper.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
