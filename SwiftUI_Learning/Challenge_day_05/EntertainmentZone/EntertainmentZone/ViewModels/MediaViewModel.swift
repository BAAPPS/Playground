//
//  MediaViewModel.swift
//  EntertainmentZone
//
//  Created by D F on 6/22/25.
//

import Foundation

@Observable
class MediaViewModel: Identifiable{
    let media: Media
    let cast: [Cast]
    
    var id: Int {media.id}
    
    init(media: Media, allCast: [Cast]){
        self.media = media
        // Filter cast members whose id is in media.castIds
        self.cast = allCast.filter { media.castIds.contains($0.id) }
    }
}
