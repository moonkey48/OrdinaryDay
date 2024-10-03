//
//  MainView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var isNewDiary = true

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
                ForEach(viewModel.diaryList) { diary in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(diary.title)
                                .font(.customLargeTitle)
                                .lineLimit(2)
                            Spacer()
                            Text(diary.monthDayWeek)
                                .font(.customTitle)
                        }
                        Image("divider")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: 360)
                }
            }
            Button {
                isNewDiary = true
            } label: {
                ZStack {
                    Image("button_large_green")
                    HStack {
                        Image("icon_pen_white")
                        Text("오늘의 일기 쓰기")
                            .font(.customLargeTitle)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .foregroundStyle(.black)
        .sheet(isPresented: $isNewDiary) {
            NewDiaryView(isNewDiary: $isNewDiary, viewModel: viewModel)
        }
    }
}

struct NewDiaryView: View {
    @Binding var isNewDiary: Bool
    @ObservedObject var viewModel: MainViewModel
    @State private var newDiary = Diary(title: "", content: "", date: Date(), weather: .wendy)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(newDiary.monthDayWeek)
                Spacer()
                Text("날씨")
                if let weather = newDiary.weather {
                    Image("icon_\(weather.rawValue)")
                }
            }
            .font(.customLargeTitle)
            .padding(.bottom, 12)
            ScrollView {
                Text("오늘 기억에 남는 순간")
                    .font(.customTitle3)
                Image("box_clear")
                    .resizable()
                    .scaledToFit()
                Text("오늘의 일기")
                    .font(.customTitle3)
                Spacer()
                ZStack {
                    VStack(spacing: 58) {
                        ForEach(0..<30, id: \.self) { _ in
                            Image("divider")
                        }
                        Spacer()
                    }
                    VStack {
                        TextField("",text: $newDiary.content, axis: .vertical)
                              .font(.customTitle)
                              .lineSpacing(30)
                              .kerning(5)
                              .lineLimit(21)
                        Spacer()
                    }
                }
            }
            HStack {
                Button {
                    isNewDiary = false
                } label: {
                    ZStack {
                        Image("button_small_orange")
                            .resizable()
                            .scaledToFit()
                        Text("취소")
                    }
                }
                Button {
                    isNewDiary = false
                } label: {
                    ZStack {
                        Image("button_small_green")
                            .resizable()
                            .scaledToFit()
                        Text("일기 끝!")
                    }
                }
            }
            .font(.customTitle)
            .foregroundStyle(.white)

        }
        .padding()
    }
}

#Preview {
    MainView()
}
