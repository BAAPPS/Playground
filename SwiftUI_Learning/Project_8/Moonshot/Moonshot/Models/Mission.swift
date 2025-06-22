//
//  Mission.swift
//  Moonshot
//
//  Created by D F on 6/22/25.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
}
