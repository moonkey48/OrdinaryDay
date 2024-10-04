//
//  Diary.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import Foundation
import SwiftData

enum WheatherState: String, Codable {
    case sunny
    case cloudy
    case partlyCloudy
    case rainy
    case windy
    case snow
}

@Model
class Diary: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var weather: WheatherState?
    var image: Data?

    init(title: String, content: String, date: Date, weather: WheatherState? = nil, image: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
        self.weather = weather
        self.image = image
    }
}

extension Diary {
    var monthDayWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
