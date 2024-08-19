//
//  API Handler.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import Foundation

class APIHandler {
    
    func request<T: Codable>(endpoint: String, method: String, completion: @escaping ((Result<T, APIErrors>) -> Void)) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.internalError))
            return
        }
        func weatherStats(completion: @escaping (Result<WeatherData, Error>) -> Void) {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=ca10f5419e656a65370b3e4f81a2ccc0")!
            let dataTask = URLSession.shared.dataTask(with: url) { date, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        call(with: request, completion: completion)
    }
    
    private func call<T: Codable>(with request: URLRequest, completion: @escaping ((Result<T, APIErrors>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
            do {
                guard let data else {
                    DispatchQueue.main.async {
                        completion(.failure(.internalError))
                    }
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.parsingError))
                }
            }
        }
        dataTask.resume()
    }
}
