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
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var newTitle = ""
    @Published var newContent = ""
    @Published var currentWeather: WheatherState?
    @Published var newDate: Date = Date.now
    @Published var newImage: UIImage?

    let weatherManager: WeatherManager = WeatherManagerImpl()
    let swiftDataManager: SwiftDataManager = SwiftDataManagerImpl()

    init() {
        Task {
            await setWeatherInfo()
            diaryList = swiftDataManager.getAllDiary()
        }
    }

    func setWeatherInfo() async {
        let currentLocation = CLLocation(latitude: 36.0190178, longitude: 129.3434808)

        let weather = await weatherManager.get(currentLocation)
        if let weather {
            switch weather.currentWeather.condition {
            case .windy, .wintryMix, .blowingDust, .flurries, .hurricane, .isolatedThunderstorms, .strongStorms:
                currentWeather = .windy
            case .snow, .blowingSnow, .frigid, .blizzard, .heavySnow, .sleet:
                currentWeather = .snow
            case .clear, .breezy, .mostlyClear, .hot, .sunFlurries, .sunShowers:
                currentWeather = .sunny
            case .cloudy, .foggy, .haze, .mostlyCloudy, .partlyCloudy, .smoky:
                currentWeather = .cloudy
            case .rain, .hail, .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .scatteredThunderstorms, .thunderstorms, .tropicalStorm:
                currentWeather = .rainy
            default:
                currentWeather = .none
            }
        }
    }

    func addNewDiary() {
        // TODO: SwiftData로 변경
        let result = swiftDataManager.createDiary(
            title: newTitle,
            content: newContent,
            weather: currentWeather,
            image: newImage)
        print(result)
//        newDiary.image = newImage?.pngData()
//        diaryList.append(newDiary)
//        newDiary = Diary(title: "", content: "", date: Date(), weather: .windy)
        
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

