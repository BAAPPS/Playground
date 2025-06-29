//
//  ArtistDetailModel.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import Foundation

struct ArtistDetailResponse: Codable {
    let resultCount: Int
    let results: [ArtistDetailModel]
}

struct ArtistDetailModel: Codable, Identifiable {
    var id: Int { trackId ?? artistId}
    
    let artistId: Int
    let trackId: Int?
    let wrapperType: String?
    let trackName: String?
    let releaseDate: String?
    let artistName: String?
    let artistType: String?
    let primaryGenreName: String?
    let artworkUrl100: String?
    let trackPrice: Double?
    let trackExplicitness: String?
    let copyright: String?
    let country: String?
    let currency: String?
}


extension ArtistDetailModel {
    init(
        artistId: Int = 19345683,
        trackId: Int = 1442434599,
        wrapperType: String = "track",
        trackName: String? = "一起走過的日子",
        releaseDate: String? = "2025-01-01T08:00:00Z",
        artistName: String = "Andy Lau",
        artistType: String? = "Artist",
        primaryGenreName: String = "Cantopop/HK-Pop",
        artworkUrl100: String? = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/da/7a/61/da7a6123-ab91-b5c2-8e90-d2c5431e3d18/00044001804120.rgb.jpg/100x100bb.jpg",
        trackPrice: Double? = 9.99,
       trackExplicitness: String? = "notExplicit",
        copyright: String? = "℗ 2025 Universal Music Ltd.",
        country: String? = "USA",
        currency: String? = "USD",
        
        
    ) {
        self.artistId = artistId
        self.trackId = trackId
        self.wrapperType = wrapperType
        self.trackName = trackName
        self.releaseDate = releaseDate
        self.artistName = artistName
        self.artistType = artistType
        self.primaryGenreName = primaryGenreName
        self.artworkUrl100 = artworkUrl100
        self.trackPrice = trackPrice
        self.trackExplicitness = trackExplicitness
        self.copyright = copyright
        self.country = country
        self.currency = currency
    }
}

extension ArtistDetailtViewModel {
    static var mock: ArtistDetailtViewModel {
        let vm = ArtistDetailtViewModel()
        vm.artistDetailsById[19345683] = [
            ArtistDetailModel(
                artistId: 19345683,
                trackId: 1001,
                wrapperType: "track",
                trackName: "Mock Track 1",
                primaryGenreName: "Cantopop/HK-Pop"
            ),
            ArtistDetailModel(
                artistId: 19345683,
                trackId: 1002,
                wrapperType: "track",
                trackName: "Mock Track 2",
                primaryGenreName: "Mandopop"
            )
        ]
        return vm
    }
}
