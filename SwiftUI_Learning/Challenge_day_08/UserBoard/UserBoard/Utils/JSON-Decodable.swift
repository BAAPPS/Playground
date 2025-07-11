//
//  Bundle-Decodable.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation

extension JSONDecoder {
    static func supabaseDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
    
    func decodeSupabase<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder.supabaseDecoder().decode(type, from: data)
    }
}
