//
//  ClimaManager.switf.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import Foundation

struct ClimaManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4235256c472d4ca247d440d4529b315a&units=metric"
    
    func fechtClima(nameCity: String) {
        let urlString = "\(weatherURL)&q=\(nameCity)"
        print(urlString)
        
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        // Crear una url
        if let url = URL(string: urlString) {
            
            // Crear el objeto URLSession
            let session = URLSession(configuration: .default)
            
            // Asignar una tarea a la sesion
            let task = session.dataTask(with: url, completionHandler: handle(data:request:error:))
            
            // Empezar la tarea
            task.resume()
        }
    }
    
    func handle(data: Data?, request: URLResponse?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        
        if let dataSure = data {
            let dataString = String(data: dataSure, encoding: .utf8)
            print(dataString!)
        }
    }
}
