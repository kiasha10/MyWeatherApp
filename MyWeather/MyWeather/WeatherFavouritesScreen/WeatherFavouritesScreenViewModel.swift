//
//  WeatherFavouritesScreenViewModel.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/15.
//

import Foundation

class WeatherFavouritesScreenViewModel {
    
    var favouriteCities: [String] = []

    func addFavoriteCity(_ city: String) {
        favouriteCities.append(city)
    }

    func getFavoriteCities() -> [String] {
        return favouriteCities
    }

    func isCityFavorite(_ city: String) -> Bool {
        return favouriteCities.contains(city)
    }
}
