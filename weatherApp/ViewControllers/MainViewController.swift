//
//  ViewController.swift
//  weatherApp
//
//  Created by Никита Ананьев on 20.01.2021.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func update(weatherData: CurrentWeather)
}

class MainViewController: UIViewController, MainViewControllerDelegate {
    
    
    @IBOutlet weak var weatherLogoLabel: UIImageView!
    
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var feelsLikeTempValueLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let networkManager = Network()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        networkManager.fetchCurrentWeather(city: "London") { [weak self] currentWeather in
            if let currentWeather = currentWeather {
                self?.update(weatherData: currentWeather)
            } 
        }
    }

    @IBAction func changeCityButtonPressed(_ sender: UIButton) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let destination = segue.destination as? PopUpViewController else { return }
           destination.delegate = self
       }
    func update(weatherData: CurrentWeather) {
        DispatchQueue.main.async {
            self.tempValueLabel.text = weatherData.tempString
            self.feelsLikeTempValueLabel.text = weatherData.feelsLikeString
            self.cityLabel.text = weatherData.cityName
            self.weatherLogoLabel.image = UIImage(systemName: weatherData.systemIconConditionString)
        }
    }

}
