//
//  Service Errors.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation

enum APIErrors: String, Error {
    case serverError
    case internalError
    case parsingError
}

enum Method {
    case GET
    case POST
}
