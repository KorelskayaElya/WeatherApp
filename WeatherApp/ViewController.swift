//
//  ViewController.swift
//  WeatherApp
//
//  Created by Эля Корельская on 30.10.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var windSpeed: UILabel!
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        startLocationManager()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
   
    // MARK: - Methods
    func startLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedWhenInUse, .authorizedAlways:
                    DispatchQueue.global(qos: .background).async {
                        self.locationManager.startUpdatingLocation()
                    }
                default:
                    break
                }
            }
        }
        
    }

    func updateView() {
        cityNameLabel.text = weatherData.timezone

        if !weatherData.current.weather.isEmpty {
            let weather = weatherData.current.weather[0]
            print("\(weather)")
            let weatherID = weatherData.current.weather[0].id
            let weatherDescription = DataSource.weatherIDs[weatherID]
            temperatureLabel.text = "\(Int(round(weatherData.current.temp - 273.15)))°"
            weatherDescriptionLabel.text = "\(weather.description)"
            weatherIconImageView.image = UIImage(named:"\(weather.icon)")
            humidity.text = "\(weatherData.current.humidity) %"
            pressure.text = "\(weatherData.current.pressure) гПа"
            windSpeed.text = "\(weatherData.current.wind_speed) м/с"
            
        } else {
            temperatureLabel.text = "-"
            weatherDescriptionLabel.text = "-"
            weatherIconImageView.image = nil
            humidity.text = "-"
            pressure.text = "-"
            windSpeed.text = "-"
            
        }
    }

    func updateWeatherInfo(latitude: Double, longitude: Double) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude.description)&lon=\(longitude.description)&lang=ru&exclude=hourly,daily&appid=b36a62334435e6536855534982102e75")!
        
        let task = session.dataTask(with: url) { data,response,error in
            guard error == nil else {
                print("Datatask error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                /// получает данные из сети
                let jsonData = try! Data(contentsOf: url)

                /// декодирует данные JSON в структуру WeatherData
                let decoder = JSONDecoder()
                
                let weatherData = try decoder.decode(WeatherData.self, from: jsonData)
                print("\(weatherData)")
                DispatchQueue.main.async {
                    /// передаем данные в обновление экрана
                    self.weatherData = weatherData
                    self.updateView()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    ///  берет заданную локацию и парсит
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            DispatchQueue.main.async {
                self.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            }
        }
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text, let coordinates = CountryCoordinateSource.countryCoordinates[city] {
            let coordinatesArray = coordinates.components(separatedBy: ",")
            if coordinatesArray.count == 2, let latitude = Double(coordinatesArray[0]), let longitude = Double(coordinatesArray[1]) {
                print("latitude \(latitude), longitude \(longitude)")
                updateWeatherInfo(latitude: latitude, longitude: longitude)
            } else {
                print("Invalid coordinates for the entered city.")
            }
        } else {
            print("City not found in the coordinates database.")
        }
        searchBar.resignFirstResponder()
    }
}

