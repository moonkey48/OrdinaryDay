//
//  WeatherData.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import CoreLocation
import Foundation
import WeatherKit

protocol WeatherManager {
    func get(_ location: CLLocation) async -> Weather?
    func getAttribution() async -> WeatherAttribution?
}

class WeatherManagerImpl: WeatherManager {
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

    func getAttribution() async -> WeatherAttribution? {
        do {
            return try await WeatherService.shared.attribution
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

