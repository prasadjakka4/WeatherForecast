//
//  MainCoordinator.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
import UIKit
import SwiftUI

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let apiManager = NetworkManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WeatherViewController.instantiate()
        let weatherViewModel = WeatherViewModel(apiManager: self.apiManager)
        weatherViewModel.coordinator = self
        vc.viewModel = weatherViewModel
        navigationController.pushViewController(vc, animated: false)
    }
    
    func loadCitySearchVC(completion: @escaping (String) -> Void, errorHandler:@escaping (String) -> ()) {
        let viewmodel = LocationSearchViewModel()
        let searchMapVC =  UIHostingController(rootView: LocationSearchView(searchModel: viewmodel))
        viewmodel.completionHandler  = {[weak self] result in
            completion(result)
            self?.navigationController.dismiss(animated: true)
        }
        self.navigationController.present(searchMapVC, animated: true)
    }
    
}
