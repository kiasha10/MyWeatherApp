//
//  WeatherForecast+CoreDataProperties.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/16.
//
//

import Foundation
import CoreData


extension WeatherForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecast> {
        return NSFetchRequest<WeatherForecast>(entityName: "WeatherForecast")
    }

    @NSManaged public var cityLocation: String?
    @NSManaged public var currentTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var weatherCondition: Int16

}
extension WeatherForecast : Identifiable {

}
