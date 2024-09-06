//
//  WeatherViewModel.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
import CoreLocation
import UIKit
import Combine

protocol WeatherViewModelDelegate: AnyObject {
    func onReceivingWeatherInfoSuccess(city: String)
    func showAlertWithMessage(title: String, message: String)
    func updateWeatherIcon(iconImage: UIImage)
    func showHideActivityView(status: Bool)
}

class WeatherViewModel {
    private var apiManager: APIService!
    var userLocation: CLLocation?
    weak var delegate: WeatherViewModelDelegate?
    weak var coordinator: MainCoordinator?
    var anyCanellable: Set<AnyCancellable> = []
    var isCurrentLocationWeather: Bool = true
    let locationManager = LocationManager.shared

    private (set) var weatherDataModel : WeatherDataModel? {
        didSet {
            self.updateViewModelDatatoUI()
        }
    }
    init(apiManager: APIService) {
        self.apiManager = apiManager
        locationManager.delegate = self
        checkForPreviousSearchResult()
    }
}

//MARK: - Networking
extension WeatherViewModel {
    func fetchWeather(request: WeatherRequest,
                      completion: @escaping (String?) -> Void) {
        self.delegate?.showHideActivityView(status: true)
        apiManager.fetchWeatherData(urlRequest: request) { [weak self] (result: Result<WeatherResponseModel, NetworkError>) in
            DispatchQueue.main.async {
                self?.delegate?.showHideActivityView(status: false)
            }
            switch result {
            case .success(let model):
                self?.weatherDataModel = WeatherDataModel().createWeatherDataModel(model: model)
                self?.weatherDataModel?.isCurrentLocation = request.currentLocation
                self?.saveWeatherData()
                completion(nil)
            case .failure(let error):
                completion(error.description)
            }
        }
    }
    
    func saveWeatherData() {
        let defaults = UserDefaults.standard
        if let quotes = self.weatherDataModel {
            defaults.set(codable: quotes, forKey: AppStrings.KEY_WEATHER_DATA)
        }
    }
    
    func fetchCurrentLocationWeather() {
        var request = WeatherRequest()
        request.currentLocation = true
        request.parameters = [
            .latitude: "\(userLocation?.coordinate.latitude ?? 0)",
            .longitude: "\(userLocation?.coordinate.longitude ?? 0)"
        ]
        self.fetchWeather(request: request) { [weak self] error in
            guard let errorMessag = error else {
                return
            }
            self?.delegate?.showAlertWithMessage(title: AppStrings.Error, message: errorMessag)
        }
    }
    
    func loadExistingWeatherData(model: WeatherDataModel) {
        self.weatherDataModel = model
    }
    
    func checkForPreviousSearchResult() {
        if let existingModel = UserDefaults.standard.codable(WeatherDataModel.self, forKey: AppStrings.KEY_WEATHER_DATA)  {
            self.weatherDataModel = existingModel
            self.isCurrentLocationWeather = existingModel.isCurrentLocation
        } else {
            self.locationManager.requestLocationServices()
        }
    }
    
    private func updateViewModelDatatoUI() {
        self.fetchWeatherIcon(urlStr: self.weatherDataModel?.imageURL ?? "")
        DispatchQueue.main.async {
            self.delegate?.onReceivingWeatherInfoSuccess(city: self.weatherDataModel?.city ?? "")
        }
    }
    
    private func fetchWeatherIcon(urlStr: String) {
        ImageDownloader.shared.downloadImage(url: urlStr).sink { errorRes in
            switch errorRes {
            case .finished:
                break
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        } receiveValue: {[weak self] image in
                self?.delegate?.updateWeatherIcon(iconImage: image)
        }.store(in: &anyCanellable)
    }
}

extension WeatherViewModel: LocationManagerDelegate {
    func updateUserLocation(_ location: CLLocation) {
        self.userLocation = location
        self.fetchCurrentLocationWeather()
    }
    
    func showLocationPermissionAlert() {
        self.delegate?.showAlertWithMessage(title: AppStrings.WEATHER_SCREEN_TITLE, message: AppStrings.LOCATION_SERVICES_DIABLED_ALERT_MSG)
    }
}

extension WeatherViewModel {
    func loadSerachCityViewController() {
        self.coordinator?.loadCitySearchVC(completion: { [weak self] city in
            guard city.isEmpty == false else {
                return
            }
            self?.isCurrentLocationWeather = false
            self?.loadWeatherInfoForCity(name: city)
        }, errorHandler: { error in
            print("Error occured while searching a city")
        })
    }
    
    func loadWeatherInfoForCity(name: String) {
        var request = WeatherRequest()
        request.parameters = [.query: name]
        self.fetchWeather(request: request) { [weak self] error in
            guard let errorMessag = error else {
                return
            }
            self?.delegate?.showAlertWithMessage(title: AppStrings.Error, message: errorMessag)
        }
    }
}
