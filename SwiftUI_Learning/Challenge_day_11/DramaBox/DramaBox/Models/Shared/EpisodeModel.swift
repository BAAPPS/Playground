//
//  EpisodeModel.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import Foundation

struct Episode: Codable, Hashable {
    let title: String
    let url: String
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title, url
        case thumbnailURL = "thumbnail_url"
    }
    
    // Custom Hashing & Equality (dedupe by title only)
    func hash(into hasher: inout Hasher) {
         hasher.combine(title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
     }
     
     static func == (lhs: Episode, rhs: Episode) -> Bool {
         lhs.title.caseInsensitiveCompare(rhs.title) == .orderedSame
     }



    struct Insert: Codable {
        let show_id: Int
        let title: String
        let url: String
        let thumbnail_url: String?
    }
    
    struct EpisodeRecord: Decodable {
        let show_id: Int
        let title: String
    }


}
