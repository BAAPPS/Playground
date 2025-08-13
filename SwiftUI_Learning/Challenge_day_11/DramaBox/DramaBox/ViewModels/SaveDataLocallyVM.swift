//
//  SaveDataLocally.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
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
    
    
    func saveCSVLocally(csvString: String, fileName: String = "export.csv") throws {
        let url = try getFileURL()
        try csvString.write(to: url, atomically: true, encoding: .utf8)
        print("✅ Saved CSV locally at: \(url.path)")
    }
}
