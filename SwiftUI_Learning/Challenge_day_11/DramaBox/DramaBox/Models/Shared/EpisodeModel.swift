//
//  EpisodeModel.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import Foundation

struct Episode: Codable {
    let title: String
    let url: String
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title, url
        case thumbnailURL = "thumbnail_url"
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
