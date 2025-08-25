//
//  String+Extensions.swift
//  DramaBox
//
//  Created by D F on 8/24/25.
//

import Foundation

// MARK: - String Helper for Episode Number
extension String {
    /// Extracts the first integer found in the string, e.g. "Ep 12" -> 12
    func extractEpisodeNumber() -> Int {
        let pattern = #"(\d+)"#
        if let match = self.range(of: pattern, options: .regularExpression) {
            return Int(self[match]) ?? 0
        }
        return 0
    }
}
