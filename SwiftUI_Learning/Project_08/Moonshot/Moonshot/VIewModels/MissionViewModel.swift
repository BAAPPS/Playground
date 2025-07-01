//
//  MissionViewModel.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import Foundation


@Observable
class MissionViewModel:Identifiable {
    let mission: Mission
    let crew: [Mission.CrewMember]
    
    var id: Int {mission.id}
    
    var displayName: String {
        "Apollo \(mission.id)"
    }
    
    var image: String{
        "apollo\(mission.id)"
    }
    
    var formattedLaunchDate: String {
        mission.launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return Mission.CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    
}
