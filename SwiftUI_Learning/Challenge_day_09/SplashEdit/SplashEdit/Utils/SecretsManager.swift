//
//  GetAPIKey.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation

enum SecretsManager {
    static func getValue(for key: String) -> String {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dict = plist as? [String: Any],
              let value = dict[key] as? String else {
            fatalError("🚫 Could not find \(key) in Secrets.plist")
        }
        
        return value
    }
}
