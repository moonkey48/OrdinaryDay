//
//  MainView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                if viewModel.diaryList.isEmpty {
                    emptyDiaryPlaceholderView
                } else {
                    diaryListView
                }
                addDiaryButtonView
            }
        }
        .foregroundStyle(.black)
        .sheet(isPresented: $viewModel.isNewDiary) {
            NewDiaryView(viewModel: viewModel)
        }
    }
}

private extension MainView {
    var headerView: some View {
        HStack(alignment: .center) {
            Text("보통의 하루")
                .font(.customXLargeTitle)
                .padding(.leading)
            Spacer()
            Image("character_small")
                .ignoresSafeArea()
//            if let currentWeather = viewModel.currentWeather {
//                VStack(alignment: .trailing) {
//                    ZStack {
//                        Button {
//                            Task {
//                                await viewModel.setWeatherInfoFromWeatherKit()
//                                viewModel.onTapButton()
//                            }
//                        } label: {
//                            Image("main_top_weatherInfo_\(currentWeather)")
//                        }
//                        VStack {
//                            HStack {
//                                Spacer()
//                                Text(currentWeather.rawValue)
//                                    .padding(.trailing)
//                            }
//                        }
//                    }
//                    .frame(width: 170, height: 128)
//                    .background(.blue)
//                    if let uiImage = viewModel.weatherAppleLogo,
//                       let weatherLink = viewModel.attributionLink{
//                        Link(destination: weatherLink, label: {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50)
//                                .padding(.trailing)
//                                .background(.red)
//                        })
//                    }
//                }
//            } else {
//                Button {
//                    Task {
//                        await viewModel.setWeatherInfoFromWeatherKit()
//                        viewModel.onTapButton()
//                    }
//                } label: {
//                    Image("character_small")
//                        .ignoresSafeArea()
//                }
//            }
        }
    }

    var diaryListView: some View {
        ScrollView {
            ForEach(viewModel.diaryList) { diary in
                NavigationLink {
                    DiaryDetailView(diary: diary, deleteAction: viewModel.deleteDiary)
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.onTapButton()
                                }
                        )
                        .buttonStyle(PlainButtonStyle())
                } label: {
                    VStack(alignment: .center) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(diary.title)
                                    .font(.customLargeTitle)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                                Text(diary.monthDayWeek)
                                    .font(.customTitle3)
                            }
                            Spacer()
                            Image("icon_arrowRight")
                        }
                        Image("divider")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: 360)
                }

            }
        }
        .scrollIndicators(.hidden)
    }

    var emptyDiaryPlaceholderView: some View {
        VStack {
            Spacer()
            Text("아래 버튼을 눌러서\n오늘의 일상을 기록해보세요 :)")
                .multilineTextAlignment(.center)
                .font(.customTitle2)
            Image("arrow_down")
                .padding(.bottom, 40)
            Spacer()
        }
    }

    var addDiaryButtonView: some View {
        Button {
            viewModel.onTapButton()
            viewModel.isNewDiary = true
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
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    MainView()
}
