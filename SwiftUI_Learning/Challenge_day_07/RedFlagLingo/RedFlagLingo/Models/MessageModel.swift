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
    var id = UUID()
    var content: String
    var date: Date
    var isFlagged: Bool
    var scamAlertMessage: String? = nil
    
    @Relationship(inverse: \UserModel.sentMessages)
    var sender: UserModel?
    
    @Relationship(inverse: \UserModel.receivedMessages)
    var receiver: UserModel?
    
    
    // Computed properties to avoid mismatch
    var senderID: UUID {
        sender?.id ?? UUID()
    }
    
    var receiverID: UUID {
        receiver?.id ?? UUID()
    }
    
    
    
    init(content: String, date: Date, isFlagged: Bool,  sender: UserModel? = nil,
         receiver: UserModel? = nil, scamAlertMessage: String? = nil) {
        self.content = content
        self.date = date
        self.isFlagged = isFlagged
        self.sender = sender
        self.receiver = receiver
        self.scamAlertMessage = scamAlertMessage
    }
}
