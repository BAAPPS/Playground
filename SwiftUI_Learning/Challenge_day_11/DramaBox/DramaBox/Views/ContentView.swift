//
//  ContentView.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var combinedVM = CombinedViewModel()

    var body: some View {
        VStack {
        }
        .task{
            let result = await combinedVM.scrapeAndUploadShows()
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
