//
//  NewDiaryView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

private extension NewDiaryView {
    enum FocusField: Hashable {
        case title
        case content
    }
}

struct NewDiaryView: View {
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focusedField: FocusField?
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
        .sheet(isPresented: $viewModel.showSelectWeather) {
            weatherSelectView
                .presentationDetents([.height(160)])
        }
        .onAppear {
            viewModel.colorScheme = colorScheme
            focusedField = .title
        }
    }
}

private extension NewDiaryView {
    @ViewBuilder
    var dateWeatherView: some View {
        HStack(alignment: .top) {
            Text(viewModel.newDate.monthDayWeek)
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                HStack {
                    Text("날씨:")
                    Button {
                        viewModel.onTapButton()
                        viewModel.showSelectWeather = true
                    } label: {
                        if let weather = viewModel.userSetedWeather {
                            Image("icon_\(weather.rawValue)")
                        } else {
                            Image("icon_black_small")
                        }
                    }
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
                if let image = viewModel.newImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 200)
                        .clipped()
                } else {
                    Image("box_clear")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onChange(of: viewModel.selectedPhoto) { _, _ in
            viewModel.convertPhoto()
        }
        .padding(.bottom, 30)

    }

    @ViewBuilder
    var titleView: some View {
        Text("일기 제목")
            .font(.customTitle3)
        TextField("", text: $viewModel.newTitle, axis: .vertical)
            .font(.customLargeTitle)
            .lineLimit(2)
            .focused($focusedField, equals: .title)
        Image("divider")
            .padding(.bottom, 30)
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
                TextField("", text: $viewModel.newContent, axis: .vertical)
                    .font(.customTitle)
                    .lineSpacing(30)
                    .focused($focusedField, equals: .content)
                Spacer()
            }
        }
    }

    @ViewBuilder
    var buttonsView: some View {
        HStack {
            Button {
                viewModel.onTapButton()
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
                viewModel.onTapButton()
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

    private var gridItems: [GridItem] {
        [ 
            GridItem(.adaptive(minimum: 100, maximum: 200)),
            GridItem(.adaptive(minimum: 100, maximum: 200)),
            GridItem(.adaptive(minimum: 100, maximum: 200))
        ]
    }

    var weatherSelectView: some View {
        LazyVGrid(columns: gridItems, spacing: 30) {
            ForEach(WheatherState.allCases, id: \.rawValue) { weather in
                Button {
                    viewModel.onTapButton()
                    viewModel.setWeatherInfoFromUser(weather)
                } label: {
                    Image("icon_\(weather)")
                }
            }
        }
    }
}
