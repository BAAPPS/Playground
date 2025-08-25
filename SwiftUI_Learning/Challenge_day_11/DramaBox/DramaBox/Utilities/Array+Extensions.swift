//
//  Array+Safe.swift
//  DramaBox
//
//  Created by D F on 8/22/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


// MARK: - Sorting & Deduplication Helper
extension Array where Element == Episode {
    /// Deduplicate by title and sort numerically by episode number
    func dedupAndSort() -> [Episode] {
        let unique = Array(Set(self))
        return unique.sorted { lhs, rhs in
            lhs.title.extractEpisodeNumber() < rhs.title.extractEpisodeNumber()
        }
    }
}
