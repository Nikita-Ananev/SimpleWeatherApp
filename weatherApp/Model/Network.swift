//
//  Network.swift
//  weatherApp
//
//  Created by Никита Ананьев on 21.01.2021.
//

import Foundation
import CoreLocation



class Network {
    var onComplition: ((CurrentWeather?) -> Void)?
    
    func fetchCurrentWeather(city:String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=fd92a9b6e1ee3d8533ffa4a9da40e78a&units=metric"
        performRequest(withURL: urlString)
    }

    func fetchCurrentWeather(forLatitude latitude: CLLocationDegrees, forLongitude longitude: CLLocationDegrees) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(String(latitude))&lon=\(String(longitude))&appid=fd92a9b6e1ee3d8533ffa4a9da40e78a&units=metric"
        performRequest(withURL: urlString)
    }
    
    fileprivate func performRequest(withURL urlString: String) {
        let urlString = urlString.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                if let currentWeather = self?.ParseJSON(with: data) {
                    self?.onComplition?(currentWeather)
                } else {
                    self?.onComplition?(nil)
                }
            }
        }
        task.resume()
    }
    
    
    fileprivate func ParseJSON(with data: Data) -> CurrentWeather? {
        do {
            let weather = try JSONDecoder().decode(WeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(weatherData: weather) else { return nil }
            return currentWeather
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
