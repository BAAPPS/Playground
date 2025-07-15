//
//  NetworkFetcher.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
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
    static func fetchAsync<T: Decodable>(
        from urlString: String,
        headers: [String: String]? = nil,
        useISO8601DateDecoding: Bool = false
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkFetcherError.badURL
        }
        return try await fetchAsync(from: url, headers: headers, useISO8601DateDecoding: useISO8601DateDecoding)
    }
    
    static func fetchAsync<T: Decodable>(
        from url: URL,
        headers: [String: String]? = nil,
        useISO8601DateDecoding: Bool = true
    ) async throws -> T {
        var request = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkFetcherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        if useISO8601DateDecoding {
            decoder.dateDecodingStrategy = .iso8601
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ JSON Decode failed")
            print(String(data: data, encoding: .utf8) ?? "No response body")
            throw NetworkFetcherError.decodingError(error)
        }
    }
}
