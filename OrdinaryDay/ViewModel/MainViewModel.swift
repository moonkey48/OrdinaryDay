//
//  MainPresenter.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI
import WeatherKit

@MainActor
final class MainViewModel: ObservableObject{
    @Published var isNewDiary = false
    @Published var diaryList: [Diary] = []
    @Published var newImage: UIImage?
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var newDiary = Diary(title: "", content: "", date: Date())

    @Published private var weather: Weather?
    let weatherData: WeatherManager = WeatherManagerImpl()

    init() {
        Task {
            await setWeatherInfo()
        }
    }

    func setWeatherInfo() async {
        let currentLocation = CLLocation(latitude: 36.0190178, longitude: 129.3434808)

        let weather = await weatherData.get(currentLocation)
        if let weather {
            switch weather.currentWeather.condition {
            case .windy, .wintryMix, .blowingDust, .flurries, .hurricane, .isolatedThunderstorms, .strongStorms:
                newDiary.weather = .windy
            case .snow, .blowingSnow, .frigid, .blizzard, .heavySnow, .sleet:
                newDiary.weather = .snow
            case .clear, .breezy, .mostlyClear, .hot, .sunFlurries, .sunShowers:
                newDiary.weather = .sunny
            case .cloudy, .foggy, .haze, .mostlyCloudy, .partlyCloudy, .smoky:
                newDiary.weather = .cloudy
            case .rain, .hail, .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .scatteredThunderstorms, .thunderstorms, .tropicalStorm:
                newDiary.weather = .rainy
            default:
                newDiary.weather = .none
            }
        }
    }

    func addNewDiary() {
        // TODO: SwiftData로 변경
        newDiary.image = newImage?.pngData()
        diaryList.append(newDiary)
        newDiary = Diary(title: "", content: "", date: Date(), weather: .windy)
    }

    func convertPhoto() {
        Task {
            if let imageData = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                if let image = UIImage(data: imageData) {
                    newImage = image
                    selectedPhoto = nil
                }
            }
        }
    }
}

