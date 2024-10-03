//
//  MainPresenter.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

class MainViewModel: ObservableObject{
    @Published var diaryList: [Diary] = [
        Diary(title: "오늘 학식 미쳤고", content: "학식 진짜 맛있었음", date: Date.now),
        Diary(title: "오늘 학식 미쳤고asdfasdf", content: "학식 진짜 맛있었음", date: Date.now),
        Diary(title: "오늘 학식 미쳤고", content: "학식 진짜 맛있었음", date: Date.now)
    ]
}

