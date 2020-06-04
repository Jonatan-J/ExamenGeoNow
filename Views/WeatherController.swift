//
//  WeatherController.swift
//
//
//  Created by Jonatan Johansson on 2020-04-27.
//  Copyright © 2020 Jonatan Johansson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherController: UIViewController{
    
    @IBOutlet weak var CountryLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    
    
    var weatherManager = Manager()
    let locationManager = CLLocationManager()
    var showLon = " Lon"
    var showLat = " Lat"
    var metersPerSecond = " M/S"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
        weatherManager.delegate = self
        inputTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
    
extension WeatherController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        inputTextField.endEditing(true)
        print(inputTextField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.endEditing(true)
        print(inputTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = inputTextField.text {
            weatherManager.fetchInfo(nameOfCity: city)
        }
        inputTextField.text = ""
    }
}

extension WeatherController: WeatherManagerDelegate{
    //Ser till att nya värden laddas för alla labels
    func didUpdateWeather(_ weatherManager: Manager, weather: WeatherModel) {
    DispatchQueue.main.async {
        self.temperatureLabel.text = weather.temperatureString
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        self.cityLabel.text =  weather.cityName
        self.CountryLabel.text = weather.countryString
        self.longitudeLabel.text = weather.longitutdeString + self.showLon
        self.latitudeLabel.text = weather.latitudeString + self.showLat
        self.windSpeedLabel.text = weather.windSpeedString + self.metersPerSecond
        self.descriptionLabel.text = weather.descriptionString.capitalized
        self.humidityLabel.text = "Humidity "+weather.humidityString + "%" 
    }
}
    func gotError(error: Error) {
        print(error)
    }
}
extension WeatherController: CLLocationManagerDelegate {
    
    //Uppdaterar plats
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchInfo(latitude: lat, longitude: lon)
        }
    }
    
    //Returnerar möjliga errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
