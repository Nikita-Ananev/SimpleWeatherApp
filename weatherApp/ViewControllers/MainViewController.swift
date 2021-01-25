//
//  ViewController.swift
//  weatherApp
//
//  Created by Никита Ананьев on 20.01.2021.
//

import UIKit
import CoreLocation

protocol MainViewControllerDelegate: AnyObject {
    func update(weatherData: CurrentWeather)
}

class MainViewController: UIViewController, MainViewControllerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var weatherLogoLabel: UIImageView!
    
    @IBOutlet weak var geoButtonLabel: UIButton!
    @IBOutlet weak var searchButtonLabel: UIButton!
    
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var feelsLikeTempValueLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let networkManager = Network()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geoButtonLabel.layer.borderWidth = 0.3
        geoButtonLabel.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        geoButtonLabel.layer.cornerRadius = geoButtonLabel.frame.height / 8
        
        searchButtonLabel.layer.borderWidth = 0.3
        searchButtonLabel.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchButtonLabel.layer.cornerRadius = geoButtonLabel.frame.height / 8
        
        

        networkManager.onComplition = { currentWeather in
            if let currentWeather = currentWeather {
                self.update(weatherData: currentWeather)
            }
        }      
    }

    @IBAction func changeCityButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.searchButtonLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3 ) {
                self.searchButtonLabel.transform = .identity
            }

        }

    }
    @IBAction func geoButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.geoButtonLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3 ) {
                self.geoButtonLabel.transform = .identity
            }

        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let destination = segue.destination as? PopUpViewController else { return }
           destination.delegate = self
       }
    
    
    
    
    
    
    func update(weatherData: CurrentWeather) {
        DispatchQueue.main.async {
            self.animateUpdate()
            self.tempValueLabel.text = weatherData.tempString
            self.feelsLikeTempValueLabel.text = weatherData.feelsLikeString
            self.cityLabel.text = weatherData.cityName
            self.weatherLogoLabel.image = UIImage(systemName: weatherData.systemIconConditionString)
        }
    }
    func animateUpdate() {
        UIView.transition(with: self.weatherLogoLabel, duration: 0.5, options: .transitionFlipFromBottom, animations: {
                    self.view.addSubview(self.weatherLogoLabel)
        }, completion: nil)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        networkManager.fetchCurrentWeather(forLatitude: latitude, forLongitude: longitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}
