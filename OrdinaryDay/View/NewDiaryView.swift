//
//  NewDiaryView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

struct NewDiaryView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            dateWeatherView
            ScrollView {
                addImageView
                titleView
                diaryWritingView
            }
            buttonsView
        }
        .padding()
    }
}

private extension NewDiaryView {
    @ViewBuilder
    var dateWeatherView: some View {
        HStack {
            Text(viewModel.newDiary.monthDayWeek)
            Spacer()
            Text("날씨")
            if let weather = viewModel.newDiary.weather {
                Image("icon_\(weather.rawValue)")
            } else {
                Button {
                    Task {
                        await viewModel.setWeatherInfo()
                    }
                } label: {
                    Image("icon_reload")
                }
            }
        }
        .font(.customLargeTitle)
        .padding(.bottom, 12)
    }

    @ViewBuilder
    var addImageView: some View {
        Text("오늘 기억에 남는 순간")
            .font(.customTitle3)
        PhotosPicker(selection: $viewModel.selectedPhoto) {
            ZStack {
                Image("box_clear")
                    .resizable()
                    .scaledToFit()
                if let image = viewModel.newImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 100)
                        .clipped()
                }
            }
        }
        .onChange(of: viewModel.selectedPhoto) { _, _ in
            viewModel.convertPhoto()
        }

    }

    @ViewBuilder
    var titleView: some View {
        Text("일기 제목")
            .font(.customTitle3)
        TextField("", text: $viewModel.newDiary.title, axis: .vertical)
            .font(.customLargeTitle)
            .lineLimit(2)
        Image("divider")
    }

    @ViewBuilder
    var diaryWritingView: some View {
        Text("오늘의 일기")
            .font(.customTitle3)
        Spacer()
        ZStack {
            VStack(spacing: 58) {
                ForEach(0..<100, id: \.self) { _ in
                    Image("divider")
                }
                Spacer()
            }
            .padding(.top, 60)
            VStack {
                TextEditor(text: $viewModel.newDiary.content)
                    .scrollContentBackground(.hidden)
                      .font(.customTitle)
                      .lineSpacing(30)
                      .kerning(5)
                Spacer()
            }
        }
    }

    @ViewBuilder
    var buttonsView: some View {
        HStack {
            Button {
                viewModel.isNewDiary = false
            } label: {
                ZStack {
                    Image("button_small_orange")
                        .resizable()
                        .scaledToFit()
                    Text("취소")
                }
            }
            Button {
                viewModel.addNewDiary()
                viewModel.isNewDiary = false
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
}
