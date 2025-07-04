//
//  Message.swift
//  RedFlagLingo
//
//  Created by D F on 7/4/25.
//

import Foundation
import SwiftData

@Model
class MessageModel: Identifiable {
    var id: UUID
    var content: String
    var date: Date
    var isFlagged: Bool
    
    init(id: UUID, content: String, date: Date, isFlagged: Bool) {
        self.id = id
        self.content = content
        self.date = date
        self.isFlagged = isFlagged
    }
}
