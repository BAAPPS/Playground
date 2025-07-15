//
//  Supabase-JSONDecoder.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation

extension JSONDecoder {
    static func supabaseJSONDecoder() -> JSONDecoder {
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
        return try JSONDecoder.supabaseJSONDecoder().decode(type, from: data)
    }
}
