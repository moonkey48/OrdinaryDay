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
    @Bindable var viewModel: DiaryDetailViewModel

    init(diary: Diary, deleteAction: @escaping (Diary) -> Void) {
        viewModel = DiaryDetailViewModel(diary, delete: deleteAction)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                navigationBarView
                dateWeatherView
                ScrollView {
                    if let _ = viewModel.diary?.image {
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
                    .resizable()
                    .scaledToFit()
                    .frame(height: 19)
                Text("일기 목록")
                    .font(.customTitle2)
                Spacer()
            }
            .foregroundStyle(.black)
        }
    }

    @ViewBuilder
    var dateWeatherView: some View {
        HStack {
            Text(viewModel.diary?.monthDayWeek ?? "")
            Spacer()
            Text("날씨:")
            if let weather = viewModel.diary?.weather {
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
                if let imageData = viewModel.diary?.image,
                   let uiImage = UIImage(data: imageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 200)
                        .clipped()
                }
            }
        } else {
            PhotosPicker(selection: $viewModel.selectedPhoto) {
                ZStack {
                    if let imageData = viewModel.editingImage,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
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
        }
    }

    @ViewBuilder
    var titleView: some View {
        if viewModel.isEdit {
            TextField("", text: $viewModel.editingTitle, axis: .vertical)
                .font(.customLargeTitle)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(height: 44)
        } else {
            HStack {
                Text(viewModel.diary?.title ?? "")
                    .font(.customLargeTitle)
                    .lineLimit(2)
                Spacer()
            }
            .frame(height: 44)
        }

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
                    TextField("", text: $viewModel.editingContent, axis: .vertical)
                        .font(.customTitle)
                        .lineSpacing(30)
                } else {
                    Text(viewModel.diary?.content ?? "")
                        .font(.customTitle)
                        .lineSpacing(30)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                    Text("수정 완료")
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
                        dismiss()
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
    DiaryDetailView(diary: .init(title: "즐거운 목요일", content: "목요일에는 맥날을 가고 그린어스에 온다. 즐겁다. 저녁에는 테니스를 쳐야 하는데 치기 귀찮다. 비가 오면 안치는데 비가 얼른 왔으면 좋겠다. 65%의 강수 확률을 믿는다. 제발", date: Date.now, weather: .cloudy)) { diary in
    }
}
