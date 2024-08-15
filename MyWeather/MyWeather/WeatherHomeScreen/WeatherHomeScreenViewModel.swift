//
//  WeatherHomeScreenViewModel.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func reloadView()
    func show(error: String)
}

class WeatherHomeScreenViewModel {
    
    var forecast: [WeatherData] = []
    var cityName: String = ""
    var currentWeather: WeatherData?
    
    private let repository: WeatherHomeScreenRepositoryType
    private weak var delegate: ViewModelDelegate?
    
    init(repository: WeatherHomeScreenRepositoryType, delegate: ViewModelDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    var numberOfDays: Int {
        forecast.count
    }
    
    func fetchWeather(at index: Int) -> WeatherData {
        return forecast[index]
    }
    
    func weatherStats() {
        print("before calling weather forecast")
        
        repository.fetchWeatherForecast { [weak self] result in
            switch result {
            case .success(let weatherStats):
                print("\(weatherStats)")
                self?.forecast = weatherStats.list
                self?.cityName = weatherStats.city.name
                self?.currentWeather = weatherStats.list.first
                self?.delegate?.reloadView()
            case .failure(let error):
                print("Oops! Parsing Error")
                self?.delegate?.show(error: error.rawValue)
            }
        }
    }
    
    private func processWeatherData(_ data: [WeatherData]) {
        let calendar = Calendar.current
        var filteredForecast: [WeatherData] = []
        var uniqueDays: Set<DateComponents> = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for weather in data {
            
            if let date = dateFormatter.date(from: weather.dt_txt) {
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                
                if !uniqueDays.contains(components) {
                    uniqueDays.insert(components)
                    filteredForecast.append(weather)
                }
            }
            
            if filteredForecast.count == 5 { break }
        }
        
        filteredForecast.sort {
            if let date1 = dateFormatter.date(from: $0.dt_txt),
               let date2 = dateFormatter.date(from: $1.dt_txt) {
                return date1 < date2
            }
            return false
        }
        self.forecast = filteredForecast
        self.delegate?.reloadView()
    }
}


