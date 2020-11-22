//
//  ClimaData.swfit.swift
//  Clima
//
//  Created by Jose Angel Cortes Gomez on 22/11/20.
//

import Foundation

struct ClimaData: Codable {
    let name: String
    let cod: Int
    let main: Main
    let weather : [Weather]
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}
