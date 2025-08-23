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
