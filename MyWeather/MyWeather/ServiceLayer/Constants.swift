//
//  Constants.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation
import UIKit

struct Endpoint {
    
    static let weatherForecast = "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=ca10f5419e656a65370b3e4f81a2ccc0"
}

struct TableViewIdentifiers {
    
    static let homeScreenIdentifier = "homeScreenIdentifier"
    static let WeatherHomeScreenTableViewCell = "WeatherHomeScreenTableViewCell"
}

struct SegueIdentifiers {
    
    static let favouritesScreenIdentifier = "displayFavouritesScreen"
}

struct WeatherResponses {
    
    static func weatherCondition(for condition: Int) -> String {
        switch condition {
        case 500...504: return "Rain"
        case 800: return "Sunny"
        case 801...804: return "Cloudy"
        default: return "Sunny"
        }
    }
    
    static func weatherIcons(for condition: Int) -> UIImage {
        switch condition {
        case 500...504: return UIImage(named: "Rain") ?? UIImage()
        case 801...804: return UIImage(named: "partlyCloudy") ?? UIImage()
        case 800: return UIImage(named: "Clear") ?? UIImage()
        default: return UIImage(named: "Clear") ?? UIImage()
        }
    }
    
    static func backgroundWeatherTheme(for condition: Int) -> UIImage {
        switch condition {
        case 500...504: return UIImage(named: "forest_rainy") ?? UIImage()
        case 801...804: return UIImage(named: "forest_cloudy") ?? UIImage()
        case 800: return UIImage(named: "forest_sunny") ?? UIImage()
        default: return UIImage(named: "forest_sunny") ?? UIImage()
        }
    }
    
    static func backgroundThemeColour(for condition: Int) -> UIColor {
        switch condition {
        case 500...504: return UIColor.rainy
        case 801...804: return UIColor.cloudy
        case 800: return UIColor.sunny
        default: return UIColor.sunny
        }
    }
}
    
func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }
