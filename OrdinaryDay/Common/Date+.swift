//
//  Date+.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

import Foundation

extension Date {
    var monthDayWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
