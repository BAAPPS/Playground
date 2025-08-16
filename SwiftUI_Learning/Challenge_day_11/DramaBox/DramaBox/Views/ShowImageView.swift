//
//  ShowImageView.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import SwiftUI
import Kingfisher

struct ShowImageView: View {
    let url: URL?
    
    var body: some View {
            if let url = url {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: url)
            }
    }
}

#Preview {
    ShowImageView(url: URL(string: "https://via.placeholder.com/600x800"))
}
