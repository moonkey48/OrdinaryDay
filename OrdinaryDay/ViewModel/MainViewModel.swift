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
    @Published var newDiary = Diary(title: "", content: "", date: Date(), weather: .wendy)

    @Published private var weather: Weather?
    let weatherData: WeatherData = WeatherDataImpl()

    init() {
        Task {
            await getweatherInfo()
        }
    }

    private func getweatherInfo() async {
        let currentLocation = CLLocation(latitude: 36.0190178, longitude: 129.3434808)

        let weather = await weatherData.get(currentLocation)
        print(weather?.currentWeather ?? "")
    }

    func addNewDiary() {
        // TODO: SwiftData로 변경
        newDiary.image = newImage?.pngData()
        diaryList.append(newDiary)
        newDiary = Diary(title: "", content: "", date: Date(), weather: .wendy)
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

