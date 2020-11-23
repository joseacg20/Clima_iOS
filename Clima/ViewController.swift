//
//  ViewController.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegate {
    
    func ifError(error: Error){
        print(error.localizedDescription)
        
        DispatchQueue.main.async {
            self.cityLabel.text = error.localizedDescription
        }
    }
    
    func updateWeather(weather: ClimaModel) {
        
//        print(weather.description)
//        print(weather.temp)
//        print(weather.weatherCondicion)
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.description
            self.tempLabel.text = String(weather.temp)
            self.weatherImageView.image = UIImage(systemName: weather.weatherCondicion)
        }
    }
    
    var weatherManager = ClimaManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Cargamos el delegado del ClimaManager
        weatherManager.delegate = self
        
        // Implementar el delagado para el teclado
        searchTextField.delegate = self
    }
    
    // Programar el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        cityLabel.text = searchTextField.text
        return true
    }
    
    // Validacion del textField (para saber si esta vacio)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Escribe la ciudad"
            return false
        }
    }
    
    @IBAction func ButtonSearch(_ sender: UIButton) {
//        cityLabel.text = searchTextField.text
        weatherManager.fechtClima(nameCity: searchTextField.text!)
    }
}
