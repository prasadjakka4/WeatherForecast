//
//  WeatherViewController.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import UIKit

class WeatherViewController: UIViewController,StoryBoardHelper {
    @IBOutlet weak private var weatherDescIcon: UIImageView!
    @IBOutlet weak var weatherDataTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLocationImageView: UIImageView!

    // MARK: - Properties
    var viewModel : WeatherViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppStrings.WEATHER_SCREEN_TITLE
        viewModel.delegate = self
        setupWeatherTableView()
    }
    
    private func setupWeatherTableView() {
        weatherDataTableView.delegate = self
        weatherDataTableView.dataSource = self
    }
    
    @IBAction func onSelectfetchCityButtonAction() {
        viewModel.loadSerachCityViewController()
    }
}


//MARK: - Spinner
extension WeatherViewController: ActivityViewPresentable {}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel.weatherDataModel else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDataCell", for: indexPath) as? WeatherDataCell else {
            fatalError("Failed to create TableViewCell")
        }
        cell.configureData(model: viewModel)
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func onReceivingWeatherInfoSuccess(city: String) {
        self.userLocationImageView.isHidden = true
        DispatchQueue.main.async {
            if self.viewModel.isCurrentLocationWeather {
                self.titleLabel.textColor = .systemBlue
                self.titleLabel.text = "\(AppStrings.TITLE_WEATHER_IFO) \(city)(\(AppStrings.CURRENT_LOCATION))"
                self.userLocationImageView.isHidden = false
                self.userLocationImageView.makeRounded()
            } else {
                self.titleLabel.textColor = .blue
                self.titleLabel.text = "\(AppStrings.TITLE_WEATHER_IFO)  \(city)"
            }
            self.weatherDataTableView.reloadData()
        }
    }
    
    func showAlertWithMessage(title: String, message: String) {
        self.presentSimpleAlert(title:AppStrings.Error, message: message)
    }
    
    func updateWeatherIcon(iconImage: UIImage) {
        DispatchQueue.main.async {
            self.weatherDescIcon.image = iconImage
        }
    }
    
    func showHideActivityView(status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.showActivityInidcator()
            } else {
                self.hideActivityInidicator()
            }
        }
    }
}
