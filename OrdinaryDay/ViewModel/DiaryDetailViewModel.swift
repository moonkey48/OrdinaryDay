//
//  DiaryDetailViewModel.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class DiaryDetailViewModel: ObservableObject {
    @Published var diary: Diary
    @Published var isEdit = false
    @Published var isShowDeleteAlert = false
    @Published var editingDiary: Diary
    @Published var selectedPhoto: PhotosPickerItem?

    init(_ currentDiary: Diary) {
        diary = currentDiary
        editingDiary = currentDiary
    }

    func startEditing() {
        isEdit = true
        editingDiary = diary
    }
    
    func cancelEditing() {
        isEdit = false
    }

    func updateDiary() {
        diary = editingDiary
        isEdit = false
    }

    func showDeleteAlert() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isShowDeleteAlert = true
        }
    }

    func cancelDeleteDiary() {
        withAnimation(.easeInOut(duration: 0.1)) {
            isShowDeleteAlert = false
        }
    }

    func deleteDiary() {
        withAnimation(.easeInOut(duration: 0.1)) {
            isShowDeleteAlert = false
        }
    }

    func convertPhoto() {
        Task {
            if let imageData = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                editingDiary.image = imageData
            }
        }
    }
}
