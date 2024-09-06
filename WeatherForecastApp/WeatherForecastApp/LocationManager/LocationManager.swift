//
//  LocationManager.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func showLocationPermissionAlert()
    func updateUserLocation(_ location: CLLocation)
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    private override init(){}
    let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    func requestLocationServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}
//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted, .notDetermined:
            self.delegate?.showLocationPermissionAlert()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.delegate?.updateUserLocation(location)
        }
    }
}
