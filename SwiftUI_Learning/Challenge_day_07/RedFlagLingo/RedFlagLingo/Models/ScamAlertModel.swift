//
//  ScamAlertModel.swift
//  RedFlagLingo
//
//  Created by D F on 7/4/25.
//

import Foundation
import SwiftData

@Model
class ScamAlertModel: Identifiable {
    var id: UUID
    var scamType: String
    var severity: String
    var matchedKeywords: [String]
    var alertMessage: String
    
    // One-to-one relationship to the message this alert belongs to
    // Each message shall have zero or one alert
    @Relationship(deleteRule: .cascade)
    var message: MessageModel
    
    init(id: UUID, scamType: String, severity: String, matchedKeywords: [String], alertMessage: String, message: MessageModel) {
        self.id = id
        self.scamType = scamType
        self.severity = severity
        self.matchedKeywords = matchedKeywords
        self.alertMessage = alertMessage
        self.message = message
    }

}
