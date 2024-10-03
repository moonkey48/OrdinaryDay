//
//  Diary.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import Foundation

enum Wheather: String {
    case sunny
    case cloudy
    case rainy
    case wendy
    case snow
}

struct Diary: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var date: Date
    var weather: Wheather?
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
