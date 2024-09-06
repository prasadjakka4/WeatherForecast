//
//  WeatherViewModelTests.swift
//  WeatherForecastAppTests
//
//  Created by Prasad Jakka on 9/5/24.
//

import XCTest
import CoreLocation
final class WeatherViewModelTests: XCTestCase {

    //MARK: - Variables
    var sut: WeatherViewModel!
    var apiManager: MockNetWorkManager<WeatherResponseModel>!
    //MARK: - Setup
    override func setUp() {
        super.setUp()
        apiManager = MockNetWorkManager()
        sut = WeatherViewModel(apiManager: apiManager)
    }
    
    //MARK: - Tests
    
    func testWeatherViewModelFetchWeatherSuccess() {
        let weather: WeatherResponseModel = MockFilehandler.readDataFromFile(at: "WeatherMockData")
        apiManager.model = weather
        var request = WeatherRequest()
        request.parameters = [.query: "London"]
        let expectation = XCTestExpectation(description: "Reload  triggered")
        sut.fetchWeather(request: request) { error in
            expectation.fulfill()
            XCTAssertEqual("London", self.sut.weatherDataModel?.city)
        }
        apiManager.fetchWithSuccess()
        let temparature = "\(Int(weather.main?.temparature ?? 0.0)) º"
        if  let model = sut.weatherDataModel?.createWeatherDataModel(model: weather) {
            XCTAssertEqual(model.temparature, temparature)
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWeatherViewModelFetchWeatherError() {
        let expectation = XCTestExpectation(description: "Fetch Weather Data ")
        let emptyModel = WeatherResponseModel(
            weather: nil, base: nil, main: nil, visibility: nil,
            wind: nil, date: nil, id: nil, name: nil, message: nil
        )
        var request = WeatherRequest()
        request.parameters = [.query: "London"]
        apiManager.model = emptyModel
        sut.fetchWeather(request: request) { error in
            expectation.fulfill()
            if let errorMessage = error {
               XCTAssertEqual("No Data received from the server.", errorMessage)
            }
        }
        apiManager.fetchWithError(.noData)
        XCTAssertTrue(apiManager.isDataFetched, "Data should be fetched")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWeatherDataModel() {
        let weather: WeatherResponseModel = MockFilehandler.readDataFromFile(at: "WeatherMockData")
        let weatherFormatted = WeatherDataModel().createWeatherDataModel(model: weather)
        let temparature = "\(Int(weather.main?.temparature ?? 0.0)) º"
        XCTAssertEqual(weatherFormatted.temparature, temparature, "Both temp.s should be equal.")
    }
    
    func testWeatherViewModelloadWeatherInfoSuccess() {
        let weather: WeatherResponseModel = MockFilehandler.readDataFromFile(at: "WeatherMockData")
        apiManager.model = weather
        let expectation = XCTestExpectation(description: "Reload  triggered")
        sut.loadWeatherInfoForCity(name: "London")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {
            expectation.fulfill()
            XCTAssertEqual("London", self.sut.weatherDataModel?.city)
        }
        apiManager.fetchWithSuccess()
        let temparature = "\(Int(weather.main?.temparature ?? 0.0)) º"
        if  let model = sut.weatherDataModel?.createWeatherDataModel(model: weather) {
            XCTAssertEqual(model.temparature, temparature)
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testWeatherViewModelfetchCurrentLocationWeather() {
        let weather: WeatherResponseModel = MockFilehandler.readDataFromFile(at: "WeatherMockData")
        apiManager.model = weather
        let expectation = XCTestExpectation(description: "Reload  triggered")
        sut.fetchCurrentLocationWeather()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {
            expectation.fulfill()
            XCTAssertEqual("London", self.sut.weatherDataModel?.city)
        }
        self.apiManager.fetchWithSuccess()
        let temparature = "\(Int(weather.main?.temparature ?? 0.0)) º"
        if  let model = sut.weatherDataModel?.createWeatherDataModel(model: weather) {
            XCTAssertEqual(model.temparature, temparature)
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testWeatherViewModelupdateUserLocation() {
        let cllocation = CLLocation.init(latitude: 33, longitude: -117)
        sut.updateUserLocation(cllocation)
        XCTAssertEqual(cllocation, sut.userLocation)
    }
    
    func testWeatherViewModelLoadExistingWeatherModelData() {
        let weather: WeatherResponseModel = MockFilehandler.readDataFromFile(at: "WeatherMockData")
        if  let model = sut.weatherDataModel?.createWeatherDataModel(model: weather) {
            sut.loadExistingWeatherData(model: model)
            XCTAssertEqual(model.city, sut.weatherDataModel?.city)

        }
    }
    
    func testLocationManager() {
        sut.locationManager.requestLocationServices()
        XCTAssertNotNil(sut.locationManager.delegate)
    }
    //MARK: - Tear down
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

}
