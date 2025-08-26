//
//  FileManager+Documents.swift
//  Flashzilla
//
//  Created by D F on 8/26/25.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func save<T: Encodable>(_ object: T, to filename: String) {
        let url = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            print("Saved to \(url)")
        } catch {
            print("Failed to save JSON:", error)
        }
    }
    
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        let url = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Failed to load JSON:", error)
            return nil
        }
    }
}
