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
    @Published var diary: Diary?
    @Published var error: DataError?
    @Published var isEdit = false
    @Published var isShowDeleteAlert = false
    @Published var editingDiary: Diary
    @Published var selectedPhoto: PhotosPickerItem?

    private let swiftDataManager: SwiftDataManager
    private let deleteAction: (Diary) -> Void

    init(_ currentDiary: Diary, delete: @escaping (Diary) -> Void) {
        diary = currentDiary
        editingDiary = currentDiary
        swiftDataManager = SwiftDataManagerImpl()
        deleteAction = delete
    }

    func startEditing() {
        isEdit = true
        guard let diary else { return }
        editingDiary = diary
    }
    
    func cancelEditing() {
        isEdit = false
    }

    func updateDiary() {
        guard let diary else { return }
        self.diary = editingDiary
        switch swiftDataManager.updateDiary(diary: diary) {
        case .success(_):
            print("success to update")
        case .failure(let failure):
            error = failure
        }
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
        guard let diary else {
            withAnimation(.easeInOut(duration: 0.1)) {
                isShowDeleteAlert = false
            }
            return
        }
        deleteAction(diary)
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
