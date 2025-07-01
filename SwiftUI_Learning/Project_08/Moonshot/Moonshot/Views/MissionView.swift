//
//  MissionView.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import SwiftUI

struct MissionView: View {
    let missionViewModel: MissionViewModel

    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.missionViewModel = MissionViewModel(mission: mission, astronauts: astronauts)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(missionViewModel.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    .padding(.top)
                
                VStack {
                    Text(missionViewModel.formattedLaunchDate)
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding(.vertical)
                .frame(maxWidth: 250)
                .background(.lightBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y:5)
                
                RectangleDivider()
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .padding(.bottom, 5)
                    
                    Text(missionViewModel.mission.description)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.horizontal)
                
                RectangleDivider()
                
                Text("Crew Members")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom, 5)
                
                CrewMembersView(crew: missionViewModel.crew)
                
            }
            .padding(.bottom)
        }
        .navigationTitle(missionViewModel.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
   MissionView(mission: missions[0], astronauts: astronauts)
      
}
