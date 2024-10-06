//
//  MainPresenter.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import Combine
import SwiftUI
import PhotosUI
import WeatherKit

@MainActor
final class MainViewModel: ObservableObject{
    @Published var isNewDiary = false
    @Published var error: DataError?
    @Published var diaryList: [Diary] = []
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var newTitle = ""
    @Published var newContent = ""
    @Published var currentWeather: WheatherState?
    @Published var newDate: Date = Date.now
    @Published var newImage: UIImage?
    @Published var attributionLink: URL?
    @Published var weatherAppleLogo: UIImage?
    @Published var colorScheme: ColorScheme?

    private let weatherManager: WeatherManager = WeatherManagerImpl()
    private let swiftDataManager: SwiftDataManager = SwiftDataManagerImpl()
    private let locationMananger: LocationManager = LocationManagerImpl()
    private let hapticManager: HapticManager? = HapticManagerImpl()

    init() {
        Task {
            fetchDiaryList()
            locationMananger.auth()
        }
    }

    func onTapButton() {
        hapticManager?.startHaptic(
            intensity: HapticManagerImpl.defaultIntensity,
            sharpness: HapticManagerImpl.defaultSharpness)
    }

    func setWeatherInfo() async {
        guard let currentLocation = locationMananger.getLocation() else {
            locationMananger.auth()
            currentWeather = .none
            return
        }
        guard let attribution = try? await weatherManager.getAttribution(),
              let colorScheme
        else {
            currentWeather = .none
            return
        }
        attributionLink = attribution.legalPageURL
        let attributionLogoURL = colorScheme == .light ? attribution.combinedMarkLightURL : attribution.combinedMarkDarkURL

        loadImage(url: attributionLogoURL)

        let weather = await weatherManager.get(currentLocation)
        if let weather {
            switch weather.currentWeather.condition {
            case .windy, .wintryMix, .blowingDust, .flurries, .hurricane, .isolatedThunderstorms, .strongStorms:
                currentWeather = .windy
            case .snow, .blowingSnow, .frigid, .blizzard, .heavySnow, .sleet:
                currentWeather = .snow
            case .clear, .breezy, .mostlyClear, .hot, .sunFlurries, .sunShowers:
                currentWeather = .sunny
            case .cloudy, .foggy, .haze, .mostlyCloudy, .smoky:
                currentWeather = .cloudy
            case .partlyCloudy:
                currentWeather = .partlyCloudy
            case .rain, .hail, .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .scatteredThunderstorms, .thunderstorms, .tropicalStorm:
                currentWeather = .rainy
            default:
                currentWeather = .none
            }
        }
    }

    func fetchDiaryList() {
        diaryList = swiftDataManager.getAllDiary()
    }

    func deleteDiary(diary: Diary) {
        switch swiftDataManager.removeDiary(diary: diary) {
        case .success(_):
            fetchDiaryList()
        case .failure(let failure):
            error = failure
        }
    }

    func addNewDiary() {
        let result = swiftDataManager.createDiary(
            title: newTitle,
            content: newContent,
            weather: currentWeather,
            image: newImage)
        switch result {
        case .success(_):
            fetchDiaryList()
        case .failure(let failure):
            error = failure
        }
        newTitle = ""
        newContent = ""
        newImage = nil
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

private extension MainViewModel {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.weatherAppleLogo = image
                    }
                }
            }
        }
    }
}
