//
//  ShowDetails.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation

struct ShowDetails: Codable {
    let schedule: String
    let subtitle: String
    let genres: [String]
    let year: String
    let description: String
    let thumbImageURL: String?
    let cast: [String]
    let title: String
    let bannerImageURL: String?
    let episodes: [Episode]?
    

    struct Insert: Codable {
        let title: String
        let subtitle: String
        let schedule: String
        let genres: [String]
        let cast: [String]
        let year: String
        let description: String
        let thumb_image_url: String?
        let banner_image_url: String?
    }
}
struct Episode: Codable {
    let title: String
    let url: String
    let thumbnailURL: String?
    
    
    struct Insert: Codable {
        let show_id: Int
        let title: String
        let url: String
        let thumbnail_url: String?
    }
}

