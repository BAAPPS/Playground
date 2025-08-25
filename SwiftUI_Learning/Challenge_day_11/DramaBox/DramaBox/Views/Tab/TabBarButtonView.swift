//
//  TabBarButtonView.swift
//  DramaBox
//
//  Created by D F on 8/20/25.
//

import SwiftUI

struct TabBarButtonView: View {
    let index: Int
    let systemIcon: String
    let title: String
    @Binding var selectedTab: Int
    var body: some View {
        Button {
            selectedTab = index
        } label: {
            VStack {
                Image(systemName: systemIcon)
                    .font(.system(size: selectedTab == index ? 24 : 20))
                Text(title)
                    .font(.system(size: 16, weight: selectedTab == index ? .bold : .regular))
            }
            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.8))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: Int = 0
    TabBarButtonView(index: 0, systemIcon: "", title: "Newest", selectedTab: $selectedTab)
}
