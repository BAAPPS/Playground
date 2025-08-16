//
//  ShowDetails.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation

import Foundation

struct ShowDetails: Codable, ShowDisplayable {
    let schedule: String
    let subtitle: String?
    let genres: [String]
    let year: String
    let description: String
    let thumbImageURL: String?
    let cast: [String]
    let title: String
    let bannerImageURL: String?
    let episodes: [Episode]?

    // computed id for protocol
    var id: String {
        "\(title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))-\(year)"
    }

    enum CodingKeys: String, CodingKey {
        case schedule, subtitle, genres, year, description, cast, title, episodes
        case thumbImageURL = "thumb_image_url"
        case bannerImageURL = "banner_image_url"
    }

    // Insert type for Supabase upload
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
