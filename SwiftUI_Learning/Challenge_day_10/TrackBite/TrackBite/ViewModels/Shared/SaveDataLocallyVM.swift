//
//  SaveDataLocallyVM.swift
//  TrackBite
//
//  Created by D F on 7/30/25.
//

import Foundation
import Observation

@Observable
class SaveDataLocallyVM<T: Codable> {
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    private func getFileURL() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "SaveDataLocallyVM", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Could not locate documents directory"])
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func saveLocally(_ items: [T]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(items)
        let url = try getFileURL()
        try data.write(to: url, options: [.atomic])
        print("✅ Saved \(fileName) locally at: \(url.path)")
    }
    
    func loadLocally() throws -> [T] {
        let url = try getFileURL()
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let items = try decoder.decode([T].self, from: data)
        print("✅ Loaded \(fileName) locally from: \(url.path)")
        return items
    }
}
