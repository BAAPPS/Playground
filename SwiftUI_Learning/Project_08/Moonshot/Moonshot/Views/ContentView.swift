//
//  ContentView.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import SwiftUI

struct ContentView: View {
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    // Create MissionViewModels from decoded data
    var missionViewModels: [MissionViewModel] {
        missions.map { MissionViewModel(mission: $0, astronauts: astronauts) }
    }
    
    @State private var showingGrid = false
    
    var body: some View {
        
        NavigationStack {
            Group{
                if showingGrid{
                    GridLayoutView(missions: missionViewModels, astronauts: astronauts)
                        .navigationDestination(for: Mission.self) { mission in
                            MissionView(mission: mission, astronauts: astronauts)
                        }
                }else{
                    ListLayoutView(missions: missionViewModels, astronauts: astronauts)
                        .navigationDestination(for: Mission.self) { mission in
                            MissionView(mission: mission, astronauts: astronauts)
                        }
                }
            }
            .navigationTitle("Moonshot")
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar{
                Button{
                    showingGrid.toggle()
                } label:{
                    Label("Switch Layout", systemImage: showingGrid ? "list.bullet" : "square.grid.2x2")
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
