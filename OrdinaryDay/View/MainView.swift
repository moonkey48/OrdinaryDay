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
    }

    var diaryListView: some View {
        ScrollView {
            ForEach(viewModel.diaryList) { diary in
                NavigationLink {
                    DiaryDetailView(diary: diary, deleteAction: viewModel.deleteDiary)
                } label: {
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
        }
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
        }
    }
}

#Preview {
    MainView()
}
