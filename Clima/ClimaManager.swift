//
//  ClimaManager.switf.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import Foundation

struct ClimaManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4235256c472d4ca247d440d4529b315a&units=metric&lang=es"
    
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
            let task = session.dataTask(with: url) { (data, request, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let dataSure = data {
                    // Decodificar el objeto JSON de la API
                    self.parseJSON(weatherData: dataSure)
                    
                }
            }
            
            // Empezar la tarea
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        
        let decoder = JSONDecoder()
        do {
            let dataDecoder = try decoder.decode(ClimaData.self, from: weatherData)
            print(dataDecoder.name)
            print(dataDecoder.cod)
            print(dataDecoder.main.temp)
            print(dataDecoder.main.humidity)
            print(dataDecoder.weather[0].description)
            print("Latitud: \(dataDecoder.coord.lat), Longitud: \(dataDecoder.coord.lon)")
        } catch {
            print(error)
        }
    }
}
