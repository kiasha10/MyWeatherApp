//
//  WeatherFavouritesScreenUnitTest.swift
//  MyWeatherTests
//
//  Created by Kiasha Rangasamy on 2024/08/19.
//
import XCTest
@testable import MyWeather

class WeatherFavouritesScreenViewModelTests: XCTestCase {
    
    var viewModel: WeatherFavouritesScreenViewModel!

    override func setUp() {
        super.setUp()
        viewModel = WeatherFavouritesScreenViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddFavouriteCity() {
        let city = "New York"
        viewModel.addFavouriteCity(city)
        XCTAssertTrue(viewModel.getFavouriteCities().contains(city))
    }

    func testGetFavouriteCities_whenNoCitiesAdded() {
        let favouriteCities = viewModel.getFavouriteCities()
        XCTAssertTrue(favouriteCities.isEmpty)
    }

    func testGetFavouriteCities_whenCitiesAdded() {
        let cities = ["New York", "Los Angeles", "Chicago"]
        cities.forEach { viewModel.addFavouriteCity($0) }
        let favouriteCities = viewModel.getFavouriteCities()
        XCTAssertEqual(favouriteCities, cities)
    }

    func testGetFavouriteCities_afterRemovingCity() {
        let city = "New York"
        viewModel.addFavouriteCity(city)
        viewModel.addFavouriteCity("Los Angeles")
        viewModel.addFavouriteCity("Chicago")
        viewModel.favouriteCities.removeAll { $0 == city }
        let favouriteCities = viewModel.getFavouriteCities()
        XCTAssertFalse(favouriteCities.contains(city))
    }

    func testGetFavouriteCities_whenCitiesAddedAndCleared() {
        let cities = ["New York", "Los Angeles", "Chicago"]
        cities.forEach { viewModel.addFavouriteCity($0) }
        viewModel.favouriteCities.removeAll()
        let favouriteCities = viewModel.getFavouriteCities()
        XCTAssertTrue(favouriteCities.isEmpty)
    }

    func testIsCityFavourite_whenCityIsFavourite() {
        let city = "New York"
        viewModel.addFavouriteCity(city)
        let isFavourite = viewModel.isCityFavourite(city)
        XCTAssertTrue(isFavourite)
    }

    func testIsCityFavourite_whenCityIsNotFavourite() {
        let city = "New York"
        let isFavourite = viewModel.isCityFavourite(city)
        XCTAssertFalse(isFavourite)
    }
    
    func testAddFavouriteCity_whenCityAlreadyExists() {
        let city = "New York"
        viewModel.addFavouriteCity(city)
        let initialCount = viewModel.getFavouriteCities().count
        viewModel.addFavouriteCity(city)
        XCTAssertEqual(viewModel.getFavouriteCities().count, initialCount + 1)
        XCTAssertTrue(viewModel.getFavouriteCities().contains(city))
    }
}
