//
//  UsersModel.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import Foundation
import SwiftData


@Model
class UserModel: Identifiable{
    var id = UUID()
    var username: String
    
    @Relationship(deleteRule: .cascade)
    var sentMessages: [MessageModel] = []
    
    @Relationship(deleteRule: .cascade)
    var receivedMessages: [MessageModel] = []
    
    init(username: String) {
        self.username = username
    }
}
