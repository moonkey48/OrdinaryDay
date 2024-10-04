//
//  SwiftData.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import Foundation

protocol SwiftDataManager {
    func getAllDiary() -> [Diary]
    func getDiary(id: UUID) -> Diary?
    func removeDiary(id: UUID) -> Bool
    func updateDiary(diary: Diary) -> Bool
    func createDiary(diary: Diary) -> Bool
}
//
//final class SwiftDataManagerImpl: SwiftDataManager {
//    func getAllDiary() -> [Diary] {
//        <#code#>
//    }
//    
//    func getDiary(id: UUID) -> Diary? {
//        <#code#>
//    }
//    
//    func removeDiary(id: UUID) -> Bool {
//        <#code#>
//    }
//    
//    func updateDiary(diary: Diary) -> Bool {
//        <#code#>
//    }
//    
//    func createDiary(diary: Diary) -> Bool {
//        <#code#>
//    }
//    
//
//}
