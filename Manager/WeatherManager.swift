//
//  WeatherManager.swift
//
//  Created by Jonatan Johansson on 2020-04-29.
//  Copyright © 2020 Jonatan Johansson. All rights reserved.
//
 
import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: Manager, weather: WeatherModel)
    func gotError(error: Error)
}

struct Manager {
    let apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=5725c76628b6be5cc8336a60dbaba55d&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchInfo(nameOfCity: String){
        let urlString = "\(apiURL)&q=\(nameOfCity)"
        print(urlString)
        request(urlString: urlString)
    }
    //Stränginterpolering i URL:en för sökfunktionen
    func fetchInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(apiURL)&lat=\(latitude)&lon=\(longitude)"
        request(urlString: urlString)
    }
    
    func request(urlString: String)  {
        // Skapar en Optional URL
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
    //Parser för JSON-data från API:et
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
           
//Enbart för konsoll loggning - ignorera
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
