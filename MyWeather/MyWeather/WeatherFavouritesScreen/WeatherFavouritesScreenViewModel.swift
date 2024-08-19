//
//  WeatherFavouritesScreenViewModel.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/15.
//

import Foundation

class WeatherFavouritesScreenViewModel {
    
    var favouriteCities: [String] = []

    func addFavouriteCity(_ city: String) {
        favouriteCities.append(city)
    }

    func getFavouriteCities() -> [String] {
        return favouriteCities
    }

    func isCityFavourite(_ city: String) -> Bool {
        return favouriteCities.contains(city)
    }
}
