//
//  OrdinaryDayApp.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import SwiftData

@main
struct OrdinaryDayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Diary.self)
        }
    }
}
