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
                self?.cityName = weatherStats.city.name
                print(weatherStats.city.name)
                self?.processWeatherData(weatherStats.list)
               
//                self?.delegate?.reloadView()
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
        
        calculateOverallTemperature(from: filteredForecast)
        self.forecast = filteredForecast
        self.delegate?.reloadView()
    }

    private func calculateOverallTemperature(from forecast: [WeatherData]) {
        guard !forecast.isEmpty else { return }
        
        var minTemp: Double = .greatestFiniteMagnitude
        var maxTemp: Double = -.greatestFiniteMagnitude
        var currentTempSum: Double = 0.0
        var allWeatherDescriptions: [WeatherDescription] = []
        
        for weather in forecast {
            let tempMin = weather.main.temp_min
            let tempMax = weather.main.temp_max
            let currentTemp = weather.main.temp
            
            minTemp = min(minTemp, tempMin)
            maxTemp = max(maxTemp, tempMax)
            currentTempSum += currentTemp
            
            allWeatherDescriptions.append(contentsOf: weather.weather)
        }
        
        let overallCurrentTemp = currentTempSum / Double(forecast.count)
        
        let updatedMainWeather = MainWeather(temp: overallCurrentTemp, temp_min: minTemp, temp_max: maxTemp)
        
        self.currentWeather = WeatherData(
            dt: 0, main: updatedMainWeather,
            weather: allWeatherDescriptions,
            dt_txt: self.currentWeather?.dt_txt ?? "Unknown date"
        )
    }


}


