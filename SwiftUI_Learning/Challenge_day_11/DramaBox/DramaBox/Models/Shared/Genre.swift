//
//  Genre.swift
//  DramaBox
//
//  Created by D F on 8/24/25.
//

import Foundation

enum Genre: String, CaseIterable, Codable, Hashable {
    case drama = "Drama"
    case mystery = "Mystery"
    case action = "Action"
    case family = "Family"
    case comedy = "Comedy"
    case thriller = "Thriller"
    case historical = "Historical"
    case romance = "Romance"
    case fantasy = "Fantasy"
    case crime = "Crime"
}
