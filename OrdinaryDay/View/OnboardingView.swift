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
            HStack {
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                Spacer()
            }
            .padding(24)

        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
