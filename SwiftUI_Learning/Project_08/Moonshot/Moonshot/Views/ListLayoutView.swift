//
//  ListLayoutView.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import SwiftUI

struct ListLayoutView: View {
    
    let missions: [MissionViewModel]
    let astronauts: [String: Astronaut]
    
    var body: some View {
            List {
                ForEach(missions, id:\.mission.id) { missionViewModel in
                    NavigationLink(value: missionViewModel.mission) {
                        HStack {
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
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .listRowBackground(Color.darkBackground)
                }
            }
            .scrollContentBackground(.hidden)
        }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missionViewModels = missions.map { MissionViewModel(mission: $0, astronauts: astronauts) }
    
    return ListLayoutView(missions: missionViewModels, astronauts: astronauts)
        .background(.darkBackground)
}
