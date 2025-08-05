//
//  Place.swift
//  TrackBite
//
//  Created by D F on 8/5/25.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
    
    enum PlaceType {
        case restaurant
        case customer
        case driver
    }
}
