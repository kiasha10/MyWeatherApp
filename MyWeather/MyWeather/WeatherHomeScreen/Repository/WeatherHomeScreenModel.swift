//
//  WeatherHomeScreenModel.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation

struct WeatherModel: Codable {
    let city: City
    let list: [WeatherData]
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

struct WeatherData: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherDescription]
    let dt_txt: String
}

struct MainWeather: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherDescription: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
