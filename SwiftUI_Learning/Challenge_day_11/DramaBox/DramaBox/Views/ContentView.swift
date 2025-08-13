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
            
            Button("Scrape and Upload Shows") {
                Task {
                    await combinedVM.scrapeAndUploadShows()
                    
                    if let success = combinedVM.successMessage {
                        print(success)
                    }
                    if let error = combinedVM.errorMessage {
                        print(error)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
