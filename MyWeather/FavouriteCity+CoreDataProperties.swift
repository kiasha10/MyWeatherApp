//
//  FavouriteCity+CoreDataProperties.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/15.
//
//

import Foundation
import CoreData


extension FavouriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCity> {
        return NSFetchRequest<FavouriteCity>(entityName: "FavouriteCity")
    }

    @NSManaged public var name: String?

}

extension FavouriteCity : Identifiable {

}
