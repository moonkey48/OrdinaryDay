//
//  Diary.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import Foundation

struct Diary: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var date: Date
    var image: Data?
}

extension Diary {
    var monthDayWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
