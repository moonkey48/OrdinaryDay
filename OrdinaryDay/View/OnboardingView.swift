//
//  OnboardingView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("main")
                .resizable()
                .scaledToFit()
            Spacer()
            VStack(alignment: .leading) {
                Text("보통의 하루")
                    .font(.customXLargeTitle)
                Text("평범한 일상의 기록")
                    .font(.customTitle3)
            }
            .padding(24)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
