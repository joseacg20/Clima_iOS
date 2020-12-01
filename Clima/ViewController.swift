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
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ocultar el teclado al precionar cualquier parte de la pantalla
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
                
        view.addGestureRecognizer(tap)
        
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
    
    // Ocultar el teclado una vez que se termino de editar el textfield
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    // Buscamos en base al nombre de la ciudad
    @IBAction func ButtonSearch(_ sender: UIButton) {
        // Eliminacion del espacio que se añadel al usar el autocompletado del teclado
        let string = searchTextField.text!
        let trimmed = string.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        // Ocultar el teclado
        dismissKeyboard()
        
        weatherManager.fechtClima(nameCity: trimmed)
    }
    
    // Obtener la ubicacion por el boton de ubicacion
    @IBAction func getUbication(_ sender: UIButton) {
        // Ocultar el teclado
        dismissKeyboard()
        
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
        if error.localizedDescription == "The operation couldn’t be completed." {
            let alert = UIAlertController(title: "Error", message: "Lo sentimos intente mas tarde se acabo el timepo para obtener los datos del clima", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Metodos para actualizar interfaz de usuario
extension ViewController: ClimaManagerDelegate {
    
    // Comprobamos si existe algun error al tratar de consultar la API
    func ifError(error: Error){
        DispatchQueue.main.async {
            if error.localizedDescription == "The operation couldn’t be completed." {
                let alert = UIAlertController(title: "Error", message: "Lo sentimos intente mas tarde se acabo el timepo para obtener los datos del clima", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.localizedDescription == "The data couldn’t be read because it is missing." {
                let alert = UIAlertController(title: "Error", message: "Lo sentimos no encontramos la ciudad que esta buscando, por favor verifica el nombre o intente mas tarde", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.localizedDescription == "A data connection is not currently allowed." {
                let alert = UIAlertController(title: "Error", message: "Perdimos la coneccion de internet intente mas tarde", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Actualizamos los elementos graficos una vez que obtuvimos la respuesta de la API
    func updateWeather(weather: ClimaModel) {
        DispatchQueue.main.async {
            self.weatherImageView.image = UIImage(systemName: weather.weatherCondicion)
            self.tempLabel.text = String(weather.tempFormat)
            self.tempMaxLabel.text = "\(String(weather.tempMaxFormat))ºC"
            self.tempMinLabel.text = "\(String(weather.tempMinFormat))ºC"
            self.windLabel.text = "\(String(weather.wind)) Km"
            self.humidityLabel.text = "\(String(weather.humidity)) f"
            self.cityLabel.text = "En \(weather.nameCity) la condicion del clima es \(weather.description)"
        }
    }
}

// MARK: - Delegados para implementar Textfield
extension ViewController: UITextFieldDelegate {
    
    // Programar el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Eliminacion del espacio que se añadel al usar el autocompletado del teclado
        let string = searchTextField.text!
        let trimmed = string.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        weatherManager.fechtClima(nameCity: trimmed)
        searchTextField.resignFirstResponder()
        
        return true
    }
     
    // Ocultar el teclado una vez que se termino de editar el textfield
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
     }
}
