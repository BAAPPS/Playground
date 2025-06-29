
//
//  NetworkFetcher.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import Foundation

enum NetworkFetcherError: Error, LocalizedError {
    case badURL
    case urlSessionError(Error)
    case invalidResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL string."
        case .urlSessionError(let error):
            return "URL Session Error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid or unexpected response from server."
        case .decodingError(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
            
        }
    }
}

final class NetworkFetcher {
    static func fetchAsync<T: Decodable>(from urlString: String, dateFormat: String? = nil) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkFetcherError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkFetcherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ JSON Decode failed")
            print(String(data: data, encoding: .utf8) ?? "No response body")
            throw NetworkFetcherError.decodingError(error)
        }
        
    }
}
