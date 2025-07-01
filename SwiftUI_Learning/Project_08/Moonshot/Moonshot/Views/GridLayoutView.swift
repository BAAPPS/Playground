//
//  GridView.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import SwiftUI

struct GridLayoutView: View {
    
    let missions: [MissionViewModel]
    let astronauts: [String: Astronaut]
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(missions, id: \.mission.id) { missionViewModel in
                    NavigationLink(value: missionViewModel.mission) {
                        VStack {
                            Image(missionViewModel.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            VStack {
                                Text(missionViewModel.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(missionViewModel.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        )
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding([.horizontal, .bottom])
          
        
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missionViewModels = missions.map { MissionViewModel(mission: $0, astronauts: astronauts) }
    
    return GridLayoutView(missions: missionViewModels, astronauts: astronauts)
        .background(.darkBackground)
        .preferredColorScheme(.dark)
}
