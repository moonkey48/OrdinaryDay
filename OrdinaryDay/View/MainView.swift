//
//  MainView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct MainView: View {
    @State private var diaryList: [Diary] = [
        Diary(title: "오늘 학식 미쳤고", content: "학식 진짜 맛있었음", date: Date.now),
        Diary(title: "오늘 학식 미쳤고", content: "학식 진짜 맛있었음", date: Date.now),
        Diary(title: "오늘 학식 미쳤고", content: "학식 진짜 맛있었음", date: Date.now)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text("보통의 하루")
                    .font(.customXLargeTitle)
                    .padding()
                Spacer()
                Image("character_small")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170)
            }
            .ignoresSafeArea()
            ScrollView {
                ForEach(diaryList) { diary in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(diary.title)
                                .font(.customTitle)
                            Spacer()
                            Text(diary.monthDayWeek)
                                .font(.customTitle3)
                        }
                        Image("divider")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: 360)
                    .padding(.vertical, 12)
                }
            }
            
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    MainView()
}
