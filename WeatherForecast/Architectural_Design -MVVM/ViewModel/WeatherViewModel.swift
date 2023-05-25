//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Roobaan M T on 24/05/23.
//

import Foundation

class WeatherViewModel {
    
    var weatherResponse : WeatherResponse?
    
    let apiKey = "522db6a157a748e2996212343221502"

    func fetchForecast(city: String, completion: @escaping (Error?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(city)&days=7&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                self.weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
}
