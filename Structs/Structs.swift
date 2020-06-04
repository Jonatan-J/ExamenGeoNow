//
//  Structs.swift
//
//
//  Created by Jonatan Johansson on 2020-04-29.
//  Copyright © 2020 Jonatan Johansson. All rights reserved.
//  See example: http://api.openweathermap.org/data/2.5/weather?appid=5725c76628b6be5cc8336a60dbaba55d&q=london&units=metric

import Foundation
import CoreLocation


//vädermodell
struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let countryName: String
    let longitudeOnLabel: Double
    let latitudeOnLabel: Double
    let windSpeedOnLabel: Double
    let descriptionOnLabel: String
    let humidityOnLabel: Int

    var humidityString: String{
           return String(humidityOnLabel)
       }
    
    var temperatureString: String{
           return String(format: "%.1f", temperature)
       }

    var windSpeedString: String {
        return String(windSpeedOnLabel)
    }
   
    var countryString: String{
        return String(countryName)
    }
    var longitutdeString: String {
        return String(longitudeOnLabel)
    }
  
    var latitudeString: String {
        return String(latitudeOnLabel)
    }
    var descriptionString: String{
        return String(descriptionOnLabel)
    }
    
    //Computed property -- returnerar en individuell emoji baserat på vilket väder-id som hämtas från API:et
    var conditionName: String {
        switch conditionId {
               case 200...232:
                   return "sun"
               case 300...321:
                   return "cloud.drizzle"
               case 500...531:
                   return "cloud.rain"
               case 600...622:
                   return "cloud.snow"
               case 701...781:
                   return "cloud.fog"
               case 800:
                   return "sun.max"
               case 801...804:
                   return "cloud.bolt"
               default:
                   return "cloud"
        }
        
    }
}

//Endast för konsoll-outputs
struct Constants {
   static let temperature = "Temparature:"
   static let longitutde = "Lon:"
   static let latitude = "Lat:"
   static let desc = "Description:"
   
}

struct WeatherData: Codable {
    let name: String
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let sys: Sys
  
struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_max: Double
    let temp_min: Double
    let pressure: Double
    let humidity: Double
}
struct Coord: Codable {
    let lon: Double
    let lat: Double
}
struct Weather: Codable {
    let description: String
    let id: Int
}
struct Wind: Codable {
    let speed: Double
}
    //TODO Sunrise and Sunset is set in unix time - convert
struct Sys: Codable {
    let country: String
    let sunrise: Double
    let sunset: Double
}
}
