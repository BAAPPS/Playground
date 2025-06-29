//
//  Artists.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import Foundation


// MARK: - Genre Enum
enum Genre: String, Codable, CaseIterable {
    case cantopopHkPop = "Cantopop/HK-Pop"
    case mandopop = "Mandopop"
    case pop = "Pop"
    case hipHop = "Hip-Hop/Rap"
    case undergroundRap = "Underground Rap"
    case unknown = "Unknown"

    // Mapping from localized genre names to internal enum
    static func from(apiGenreName: String) -> Genre {
        switch apiGenreName {
        case "廣東歌/香港流行樂", cantopopHkPop.rawValue:
            return .cantopopHkPop
        case "國語流行樂", mandopop.rawValue:
            return .mandopop
        case "流行樂", pop.rawValue:
            return .pop
        case "嘻哈/說唱", hipHop.rawValue:
            return .hipHop
        case "地下饒舌", undergroundRap.rawValue:
            return .undergroundRap
        default:
            return .unknown
        }
    }

}

// MARK: - Artist Struct Model

struct ArtistModelResponse: Decodable {
    let resultCount: Int
    let results: [ArtistModel]
}

struct ArtistModel: Codable, Hashable {
    var artistName: String
    var artistLinkUrl: String
    var artistId: Int
    var amgArtistId: Int?
    var primaryGenreName: Genre
    var primaryGenreId: Int
    
    // Hashable & Equatable by artistId only
    func hash(into hasher: inout Hasher) {
        hasher.combine(artistId)
    }
    
    static func == (lhs: ArtistModel, rhs: ArtistModel) -> Bool {
        lhs.artistId == rhs.artistId
    }
    
    // Custom initializer is required to decode the Chinese genre string
    // from JSON and map it to the English `Genre` enum using `Genre.from(apiGenreName:)`.
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          artistName = try container.decode(String.self, forKey: .artistName)
          artistLinkUrl = try container.decode(String.self, forKey: .artistLinkUrl)
          artistId = try container.decode(Int.self, forKey: .artistId)
          amgArtistId = try? container.decodeIfPresent(Int.self, forKey: .amgArtistId)
          primaryGenreId = try container.decode(Int.self, forKey: .primaryGenreId)

          // Decode Chinese genre string, map it to English enum
          let genreString = try container.decode(String.self, forKey: .primaryGenreName)
          primaryGenreName = Genre.from(apiGenreName: genreString)
      }
}

// Manual initializer to enable creating ArtistModel instances
// for previews, testing, or manual construction outside JSON decoding.
extension ArtistModel {
    init(
        artistName: String,
        artistLinkUrl: String,
        artistId: Int,
        amgArtistId: Int? = nil,
        primaryGenreName: Genre,
        primaryGenreId: Int
    ) {
        self.artistName = artistName
        self.artistLinkUrl = artistLinkUrl
        self.artistId = artistId
        self.amgArtistId = amgArtistId
        self.primaryGenreName = primaryGenreName
        self.primaryGenreId = primaryGenreId
    }
}


// MARK: - Artis Class Model

//@Observable
class ArtistModelClass: Codable, Identifiable {
    var artistName: String
    var artistLinkUrl: String
    var artistId: Int
    var amgArtistId: Int?
    var primaryGenreName: String
    var primaryGenreId: Int

    init(
        artistName: String,
        artistLinkUrl: String,
        artistId: Int,
        amgArtistId: Int?,
        primaryGenreName: String,
        primaryGenreId: Int
    ) {
        self.artistName = artistName
        self.artistLinkUrl = artistLinkUrl
        self.artistId = artistId
        self.amgArtistId = amgArtistId
        self.primaryGenreName = primaryGenreName
        self.primaryGenreId = primaryGenreId
    }

    enum CodingKeys: String, CodingKey {
        case artistName
        case artistLinkUrl
        case artistId
        case amgArtistId
        case primaryGenreName
        case primaryGenreId
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let artistName = try container.decode(String.self, forKey: .artistName)
        let artistLinkUrl = try container.decode(String.self, forKey: .artistLinkUrl)
        let artistId = try container.decode(Int.self, forKey: .artistId)
        let amgArtistId = try? container.decode(Int.self, forKey: .amgArtistId) // optional decode
        let primaryGenreName = try container.decode(String.self, forKey: .primaryGenreName)
        let primaryGenreId = try container.decode(Int.self, forKey: .primaryGenreId)

        self.init(
            artistName: artistName,
            artistLinkUrl: artistLinkUrl,
            artistId: artistId,
            amgArtistId: amgArtistId,
            primaryGenreName: primaryGenreName,
            primaryGenreId: primaryGenreId
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(artistLinkUrl, forKey: .artistLinkUrl)
        try container.encode(artistId, forKey: .artistId)
        try container.encodeIfPresent(amgArtistId, forKey: .amgArtistId)
        try container.encode(primaryGenreName, forKey: .primaryGenreName)
        try container.encode(primaryGenreId, forKey: .primaryGenreId)
    }
}
