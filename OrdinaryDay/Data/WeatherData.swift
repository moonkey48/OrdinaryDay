//
//  WeatherData.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import CoreLocation
import Foundation
import WeatherKit

protocol WeatherData {
    func get(_ location: CLLocation) async -> Weather?
}

class WeatherDataImpl: WeatherData {
    private let weatherService = WeatherService()

    func get(_ location: CLLocation) async -> Weather? {
        do {
            let weather = try await Task.detached(priority: .userInitiated) { [weak self] in
                return try await self?.weatherService.weather(for: location)
            }.value
            return weather
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

