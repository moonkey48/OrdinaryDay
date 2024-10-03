//
//  DiaryDetailView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI
import PhotosUI

struct DiaryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DiaryDetailViewModel

    init(diary: Diary) {
        viewModel = DiaryDetailViewModel(diary)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                navigationBarView
                dateWeatherView
                ScrollView {
                    if let _ = viewModel.diary.image {
                        addImageView
                    }
                    titleView
                    diaryWritingView
                }
                if viewModel.isEdit {
                    editingButtonsView
                } else {
                    buttonsView
                }
            }
            .padding()
            if viewModel.isShowDeleteAlert {
                deleteAlertView
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private extension DiaryDetailView {
    var navigationBarView: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image("arrow_left")
                Text("일기 목록")
                    .font(.customLargeTitle)
                Spacer()
            }
            .foregroundStyle(.black)
        }
    }

    @ViewBuilder
    var dateWeatherView: some View {
        HStack {
            Text(viewModel.diary.monthDayWeek)
            Spacer()
            Text("날씨")
            if let weather = viewModel.diary.weather {
                Image("icon_\(weather.rawValue)")
            }
        }
        .font(.customLargeTitle)
        .padding(.bottom, 12)

    }

    @ViewBuilder
    var addImageView: some View {
        Text("오늘 기억에 남는 순간")
            .font(.customTitle3)
        if !viewModel.isEdit {
            ZStack {
                Image("box_clear")
                    .resizable()
                    .scaledToFit()
                if let imageData = viewModel.diary.image,
                   let uiImage = UIImage(data: imageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 100)
                }
            }
        }
//        PhotosPicker(selection: $viewModel.selectedPhoto) {
//            ZStack {
//                Image("box_clear")
//                    .resizable()
//                    .scaledToFit()
//                if let image = viewModel.newImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 300, height: 100)
//                }
//            }
//        }
//        .onChange(of: viewModel.selectedPhoto) { _, _ in
//            viewModel.convertPhoto()
//        }
//        Image("box_clear")
//            .resizable()
//            .scaledToFit()
    }

    @ViewBuilder
    var titleView: some View {
        if viewModel.isEdit {
            TextField("", text: $viewModel.editingDiary.title, axis: .vertical)
                .font(.customLargeTitle)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        } else {
            HStack {
                Text(viewModel.diary.title)
                    .font(.customLargeTitle)
                    .lineLimit(2)
                Spacer()
            }
        }
        Image("divider")
    }

    @ViewBuilder
    var diaryWritingView: some View {
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
                if viewModel.isEdit {
                    TextEditor(text: $viewModel.editingDiary.content)
                        .scrollContentBackground(.hidden)
                          .font(.customTitle)
                          .lineSpacing(30)
                          .kerning(5)
                } else {
                    Text(viewModel.diary.content)
                        .font(.customTitle)
                        .lineSpacing(32)
                        .kerning(5)
                        .padding(.horizontal, 12)
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    var buttonsView: some View {
        HStack {
            Button {
                viewModel.showDeleteAlert()
            } label: {
                ZStack {
                    Image("button_small_orange")
                        .resizable()
                        .scaledToFit()
                    Text("지우기")
                }
            }
            Button {
                viewModel.startEditing()
            } label: {
                ZStack {
                    Image("button_small_green")
                        .resizable()
                        .scaledToFit()
                    Text("다시 쓰기")
                }
            }
        }
        .font(.customTitle)
        .foregroundStyle(.white)
    }

    var editingButtonsView: some View {
        HStack {
            Button {
                viewModel.cancelEditing()
            } label: {
                ZStack {
                    Image("button_small_orange")
                        .resizable()
                        .scaledToFit()
                    Text("취소")
                }
            }
            Button {
                viewModel.updateDiary()
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

    var deleteAlertView: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.cancelDeleteDiary()
                }
            Image("box_alert")
            VStack {
                Spacer()
                Text("정말 일기를\n지우시겠어요?")
                    .font(.customTitle)
                Spacer()
                HStack {
                    Button {
                        viewModel.cancelDeleteDiary()
                    } label: {
                        ZStack {
                            Image("button_small_orange")
                                .resizable()
                                .scaledToFit()
                            Text("아니야")
                        }
                    }
                    Button {
                        viewModel.deleteDiary()
                    } label: {
                        ZStack {
                            Image("button_small_green")
                                .resizable()
                                .scaledToFit()
                            Text("지우기")
                        }
                    }
                }
                .font(.customTitle2)
                .foregroundStyle(.white)
                .padding()
            }
            .frame(width: 272, height: 194)
        }
    }
}


#Preview {
    DiaryDetailView(diary: .init(title: "즐거운 목요일", content: "목요일에는 맥날을 가고 그린어스에 온다. 즐겁다. 저녁에는 테니스를 쳐야 하는데 치기 귀찮다. 비가 오면 안치는데 비가 얼른 왔으면 좋겠다. 65%의 강수 확률을 믿는다. 제발", date: Date.now, weather: .cloudy))
}
