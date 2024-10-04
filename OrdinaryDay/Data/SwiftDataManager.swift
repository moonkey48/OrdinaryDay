//
//  SwiftData.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import SwiftData
import SwiftUI

enum DataError: Error {
    case networkError
    case typeError
    case unknown
}

protocol SwiftDataManager {
    func getAllDiary() -> [Diary]
    func getDiary(id: UUID) -> Diary?
    func removeDiary(diary: Diary) -> Result<Bool, DataError>
    func updateDiary(diary: Diary) -> Result<Bool, DataError>
    func createDiary(
        title: String,
        content: String,
        weather: WheatherState?,
        image: UIImage?
    ) -> Result<Bool, DataError>
}

final class SwiftDataManagerImpl: SwiftDataManager {
    let container: ModelContainer?
    let context: ModelContext?

    init() {
        container = try? ModelContainer(for: Diary.self)
        if let container {
            context = ModelContext(container)
        } else {
            context = nil
        }
    }

    func getAllDiary() -> [Diary] {
        guard let context else { return [] }
        let predicate = #Predicate<Diary> { diary in
            true
        }

        let descriptor = FetchDescriptor(predicate: predicate)
        do {
            return try context.fetch(descriptor)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getDiary(id: UUID) -> Diary? {
        return nil
    }
    
    func removeDiary(diary: Diary) -> Result<Bool, DataError> {
        guard let context else { return .failure(.unknown) }
        context.delete(diary)
        return .success(true)
    }
    
    func updateDiary(diary: Diary) -> Result<Bool, DataError> {
        guard let context else { return .failure(.typeError) }
        context.insert(diary)
        return .success(true)
    }
    
    func createDiary(
        title: String,
        content: String,
        weather: WheatherState? = nil,
        image: UIImage? = nil
    ) -> Result<Bool, DataError> {
        guard let context else { return .failure(.unknown) }
        let diary = Diary(title: title, content: content, date: Date.now, weather: weather, image: image?.pngData())
        context.insert(diary)
        return .success(true)
    }
    

}
