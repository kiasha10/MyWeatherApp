//
//  WeatherHomeScreenRepository.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation

typealias WeatherResult = (Result<WeatherModel, APIErrors>) -> Void

protocol WeatherHomeScreenRepositoryType: AnyObject {
    func fetchWeatherForecast(completion: @escaping WeatherResult)
}

class WeatherHomeScreenRepository : WeatherHomeScreenRepositoryType {
    private let apiHandler = APIHandler()
    
    func fetchWeatherForecast(completion: @escaping WeatherResult) {
        apiHandler.request(endpoint: Endpoint.weatherForecast, method: "GET", completion: completion)
    }
}
