//
//  View+Extensions.swift
//  Flashzilla
//
//  Created by D F on 8/25/25.
//

import Foundation
import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}
