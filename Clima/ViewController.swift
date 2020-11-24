//
//  ViewController.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var weatherManager = ClimaManager()
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Implementacion del delegado locationManager
        locationManager.delegate = self
        // Solicitud de ubicacion para el usuario
        locationManager.requestWhenInUseAuthorization()
        // Obtencion de la ubicacion
        locationManager.requestLocation()
        
        // Cargamos el delegado del ClimaManager
        weatherManager.delegate = self
        
        // Implementar el delagado para el teclado
        searchTextField.delegate = self
    }
    
    // Buscamos en base al nombre de la ciudad
    @IBAction func ButtonSearch(_ sender: UIButton) {
        weatherManager.fechtClima(nameCity: searchTextField.text!)
    }
    
    // Obtener la ubicacion por el boton de ubicacion
    @IBAction func getUbication(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - Procololo CLLocationManagerDelegate para obtener la ubicacion del usuario
extension ViewController: CLLocationManagerDelegate {
    
    // Actualizacion de la ubicacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let ubications = locations.last {
            // Detenemos la actualizacion constante de la ubicacion
            locationManager.stopUpdatingLocation()
            let latitud = ubications.coordinate.latitude
            let longitud = ubications.coordinate.longitude
            
            // Se hace el llamado al la funcion para obtener los datos por la ubicacion
            weatherManager.fechtClima(lat: latitud, lon: longitud)
        }
    }
    
    // Si existe un error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Metodos para actualizar interfaz de usuario
extension ViewController: ClimaManagerDelegate {
    
    // Comprobamos si existe algun error al tratar de consultar la API
    func ifError(error: Error){
        print(error.localizedDescription)
        
        DispatchQueue.main.async {
            self.cityLabel.text = error.localizedDescription
        }
    }
    
    // Actualizamos los elementos graficos una vez que obtuvimos la respuesta de la API
    func updateWeather(weather: ClimaModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.description
            self.tempLabel.text = String(weather.temp)
            self.weatherImageView.image = UIImage(systemName: weather.weatherCondicion)
        }
    }
}

// MARK: - Delegados para implementar Textfield
extension ViewController: UITextFieldDelegate {
    
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
}
