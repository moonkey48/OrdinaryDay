//
//  MainPresenter.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

@MainActor
class MainViewModel: ObservableObject{
    @Published var isNewDiary = false
    @Published var diaryList: [Diary] = []
    @Published var newImage: UIImage?
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var newDiary = Diary(title: "", content: "", date: Date(), weather: .wendy)

    func addNewDiary() {
        newDiary.image = newImage?.pngData()
        diaryList.append(newDiary)
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

