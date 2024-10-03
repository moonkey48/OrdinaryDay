//
//  MainView.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/3/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        Text("dd")
            .onAppear {
                for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) Font names: \(names)")
                }
            }
    }
}

#Preview {
    MainView()
}
