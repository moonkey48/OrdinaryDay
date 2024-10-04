//
//  ContentView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            OnboardingView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {isLoading = false
                        }
                    }
                }
        } else {
            MainView()
        }
    }
}

#Preview {
    ContentView()
}
