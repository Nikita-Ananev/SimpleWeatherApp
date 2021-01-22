//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by Никита Ананьев on 22.01.2021.
//

import Foundation
struct CurrentWeather {
    let cityName: String
    
    let temp: Double
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var feelsLike: Double
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    let conditionCode: Int
    
    var systemIconConditionString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "snow"
        case 701...781: return "smoke"
        case 800: return "sun.max"
        case 801...804: return "cloud"
            
        default: return "smoke"
        }
        
    }
    
    init?(weatherData: WeatherData) {
        cityName = weatherData.name ?? "error"
        temp = weatherData.main?.temp ?? 0
        feelsLike = weatherData.main?.feelsLike ?? 0
        
        conditionCode = weatherData.weather?.first!.id ?? 0
    }
    
}
