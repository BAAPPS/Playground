//
//  User+Extensions.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import Supabase


extension User {
    var idString: String {
        id.uuidString
    }
}
