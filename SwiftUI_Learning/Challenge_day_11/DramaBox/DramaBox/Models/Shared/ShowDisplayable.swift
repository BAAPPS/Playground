//
//  ShowDisplayable.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import Foundation

protocol ShowDisplayable {
    var id: String { get}
    var title: String { get }
    var subtitle: String? { get }
    var year: String { get }
    var description: String { get }
    var schedule: String { get }
    var genres: [String] { get }
    var cast: [String] { get }
    var episodes: [Episode]? { get }
    var thumbImageURL: String? { get }
    var bannerImageURL: String? { get }
}

extension ShowDisplayable {
    func asShowDetails() -> ShowDetails {
        // Preserve episodes if already ShowDetails
        if let existing = self as? ShowDetails {
            return existing
        }
        return ShowDetails(
            schedule: self.schedule,
            subtitle: self.subtitle,
            genres: self.genres,
            year: self.year,
            description: self.description,
            thumbImageURL: self.thumbImageURL,
            cast: self.cast,
            title: self.title,
            bannerImageURL: self.bannerImageURL,
            episodes: []
        )
    }
}
