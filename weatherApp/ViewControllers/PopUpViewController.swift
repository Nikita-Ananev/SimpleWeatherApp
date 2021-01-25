//
//  PopUpViewController.swift
//  weatherApp
//
//  Created by Никита Ананьев on 21.01.2021.
//

import UIKit
class PopUpViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: MainViewControllerDelegate?
    var searchTimer: Timer?
    let networkManager = Network()
    var newCurrentWeather: CurrentWeather?
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusErrorLabel: UILabel!
    @IBOutlet weak var applyButtonLabel: UIButton!
    
    var weatherData: WeatherData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.onComplition = {[weak self] currentWeather in
            if let currentWeather = currentWeather {
                self?.newCurrentWeather = currentWeather
                DispatchQueue.main.async {
                    self?.interfaceAfterSearch(keyword: currentWeather.cityName, isResult: true)
                }
            } else {
                DispatchQueue.main.async {
                    self?.interfaceAfterSearch(keyword: self?.cityNameTextField.text ?? "error", isResult: false)
                }
            }
        }
        
        cityNameTextField.delegate = self
        
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {

        if let newCurrentWeather = newCurrentWeather {
            delegate?.update(weatherData: newCurrentWeather)
            
        }
        dismiss(animated: true, completion: nil)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textField.text!, repeats: false)
        
    }
    
    // try to find city
    @objc func searchForKeyword(_ timer: Timer) {
        
        let keyword = timer.userInfo as! String
        if keyword.count > 2 {
            networkManager.fetchCurrentWeather(city: keyword)
        }
    }
    
    // Customize Interface after search
    func interfaceAfterSearch(keyword: String, isResult: Bool) {
        if isResult {
                self.statusErrorLabel.text = "We found \(keyword)"
                self.statusImage.image = UIImage(systemName: "checkmark")
                self.statusImage.tintColor = #colorLiteral(red: 0, green: 0.916187942, blue: 0.2306471765, alpha: 1)
                self.applyButtonLabel.isEnabled = true
                self.applyButtonLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
                self.statusErrorLabel.text = "We can't find \(self.cityNameTextField.text ?? "error city")"
                self.statusImage.tintColor = #colorLiteral(red: 0.8325281739, green: 0.2449339628, blue: 0.2483051419, alpha: 1)
                self.statusImage.image = UIImage(systemName: "info.circle")
                self.applyButtonLabel.isEnabled = false
                self.applyButtonLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    
}
