//
//  MediaModel.swift
//  EntertainmentZone
//
//  Created by D F on 6/22/25.
//

import Foundation

struct Media: Codable, Identifiable {
    let id: Int
    let title: String
    let mediaType: String
    let releaseDate: String
    let description: String
    let imageUrl: String
    let castIds: [Int]
    
}
