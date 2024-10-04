//
//  SwiftData.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import SwiftData
import SwiftUI

protocol SwiftDataManager {
    func getAllDiary() -> [Diary]
    func getDiary(id: UUID) -> Diary?
    func removeDiary(id: UUID) -> Bool
    func updateDiary(diary: Diary) -> Bool
    func createDiary(
        title: String,
        content: String,
        weather: WheatherState?,
        image: UIImage?
    ) -> Bool
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
        var predicate = #Predicate<Diary> { diary in
            true
        }

        var descriptor = FetchDescriptor(predicate: predicate)
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
    
    func removeDiary(id: UUID) -> Bool {
        return true
    }
    
    func updateDiary(diary: Diary) -> Bool {
        return true
    }
    
    func createDiary(
        title: String,
        content: String,
        weather: WheatherState? = nil,
        image: UIImage? = nil
    ) -> Bool {
        let diary = Diary(title: title, content: content, date: Date.now, weather: weather, image: image?.pngData())
        context?.insert(diary)
        return true
    }
    

}
