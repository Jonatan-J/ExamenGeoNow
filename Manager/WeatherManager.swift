//
//  WeatherManager.swift
//
//  Created by Jonatan Johansson on 2020-04-29.
//  Copyright © 2020 Jonatan Johansson. All rights reserved.
//  \\\\\\\\\\\\\
 
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: Manager, weather: WeatherModel)
    func gotError(error: Error)
    
}



struct Manager {
    let apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=5725c76628b6be5cc8336a60dbaba55d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //https is required
    //function uses string interpolation, replaces missing 'city' string in the URL so the desired city with its info is displayed
    func fetchInfo(nameOfCity: String){
        let urlString = "\(apiURL)&q=\(nameOfCity)"
        print(urlString)
        request(urlString: urlString)
    }
    
    //interpolation function for the coordinate fetch
    func fetchInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(apiURL)&lat=\(latitude)&lon=\(longitude)"
        request(urlString: urlString)
    }
    
    func request(urlString: String)  {
        // Prints raw unformated data into console
        // let dataString = String(data: safeData, encoding: .utf8)
        // print(dataString)
        // initializer creates an optional URL
        if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                   if let weather = self.parseJSON(weatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        }
                    }
                }
        
            task.resume()
        }
 
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        let country = decodedData.sys.country
            let longitude = decodedData.coord.lon
            let latitude = decodedData.coord.lat
            let wind = decodedData.wind.speed
            let description = decodedData.weather[0].description
            let humidity = decodedData.main.humidity
          
            

                let weather = WeatherModel(
                
                conditionId:id,
                cityName:name,
                temperature:temp,
                countryName:country,
                longitudeOnLabel:longitude,
                latitudeOnLabel:latitude,
                windSpeedOnLabel:wind,
                descriptionOnLabel: description,
                humidityOnLabel: Int(humidity) )
                
         
                
                
            
        
        print(weather.conditionName)
        print(Constants.temperature, decodedData.main.temp)
        print(Constants.longitutde, decodedData.coord.lon, Constants.latitude, decodedData.coord.lat)
        print(Constants.desc, decodedData.weather[0].description)
            print(weather.humidityString)
            print(weather.temperatureString)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
        
}


//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//
//        }
//
//    }


