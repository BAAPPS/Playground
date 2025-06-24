//
//  CastModel.swift
//  EntertainmentZone
//
//  Created by D F on 6/22/25.
//

import Foundation

struct Cast: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profileUrl: String
    let mediaIds: [Int]
}
