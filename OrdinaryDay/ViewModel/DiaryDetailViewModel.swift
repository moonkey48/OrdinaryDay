//
//  DiaryDetailViewModel.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

@Observable
final class DiaryDetailViewModel {
    var diary: Diary?
    var error: DataError?
    var isEdit = false
    var isShowDeleteAlert = false
    var selectedPhoto: PhotosPickerItem?
    var editingTitle = ""
    var editingContent = ""
    var editingImage: Data?
    var showImageFocused = false

    private let swiftDataManager: SwiftDataManager
    private let hapticManager: HapticManager? = HapticManagerImpl()
    private let deleteAction: (Diary) -> Void

    init(_ currentDiary: Diary, delete: @escaping (Diary) -> Void) {
        diary = currentDiary
        swiftDataManager = SwiftDataManagerImpl()
        deleteAction = delete
    }

    func onAppear() {
        onTapButton()
    }

    func onTapButton() {
        hapticManager?.startHaptic(
            intensity: HapticManagerImpl.defaultIntensity,
            sharpness: HapticManagerImpl.defaultSharpness
        )
    }

    func startEditing() {
        onTapButton()
        isEdit = true
        guard let diary else { return }
        editingTitle = diary.title
        editingContent = diary.content
        if let imageData = diary.image {
            editingImage = imageData
        }
    }
    
    func cancelEditing() {
        onTapButton()
        resetEditingProperty()
        isEdit = false
    }

    func resetEditingProperty() {
        editingTitle = ""
        editingContent = ""
        editingImage = nil
    }

    func updateDiary() {
        guard let diary else { return }
        diary.title = editingTitle
        diary.content = editingContent
        diary.image = editingImage
        resetEditingProperty()
        switch swiftDataManager.updateDiary(diary: diary) {
        case .success(_):
            print("success to update")
        case .failure(let failure):
            error = failure
        }
        isEdit = false
    }

    func showDeleteAlert() {
        onTapButton()
        withAnimation(.easeInOut(duration: 0.3)) {
            isShowDeleteAlert = true
        }
    }

    func cancelDeleteDiary() {
        onTapButton()
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
                editingImage = imageData
            }
        }
    }
}
