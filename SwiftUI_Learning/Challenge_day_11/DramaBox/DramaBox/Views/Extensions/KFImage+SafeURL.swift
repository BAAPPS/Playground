//
//  KFImage+SafeURL.swift
//  DramaBox
//
//  Created by D F on 8/22/25.
//

import Kingfisher
import SwiftUI

extension KFImage {
    static func url(from string: String?) -> KFImage {
        if let string, let url = URL(string: string) {
            return KFImage(url)
        }
        // fallback: empty URL → use a placeholder asset
        return KFImage(Bundle.main.url(forResource: "placeholder", withExtension: "png")!)

    }
}
