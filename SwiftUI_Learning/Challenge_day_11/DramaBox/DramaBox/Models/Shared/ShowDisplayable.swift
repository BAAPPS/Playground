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
