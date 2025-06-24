//
//  ContentView.swift
//  Navigation
//
//  Created by D F on 6/24/25.
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        // Still here? Start with an empty path.
        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct DetailView: View {
    
    
    var number: Int
    
    @State private var title = "Number"

    var body: some View {
        List {
            ForEach(0..<100) { i in
                NavigationLink("Select Number: \(i)", value: i)
                    .navigationTitle($title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.blue)
                    .toolbarColorScheme(.dark)
            }
           
            
        }
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Go Home"){
                                    pathStore.path = NavigationPath()
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                    Button("Go Previous") {
                                        pathStore.path.removeLast()
                                    }
                                }

                        }
                }
        }
    }
}

#Preview {
    ContentView()
}
