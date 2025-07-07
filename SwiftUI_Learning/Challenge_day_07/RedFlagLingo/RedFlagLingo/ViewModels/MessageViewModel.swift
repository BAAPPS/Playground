//
//  MessageViewModel.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import Foundation
import SwiftData
import Observation

@Observable
class MessageViewModel{
    let context: ModelContext
    let scanner: ScamScannerViewModel
    
    var users:[UserModel] = []
    
    init(context: ModelContext, scanner: ScamScannerViewModel, users: [UserModel]){
        self.context = context
        self.scanner = scanner
        self.users = users
    }
    
    func sendMessage(from senderID: UUID, to receiverID: UUID, content: String) {
        guard let sender = users.first(where: { $0.id == senderID }),
              let receiver = users.first(where: { $0.id == receiverID }) else {
            print("⚠️ Sender or receiver not found.")
            return
        }
        
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedContent.isEmpty else {
            print("⚠️ \(sender.username) tried to send an empty message to \(receiver.username)")
            return
        }
        
        let scanResult = scanner.scan(messageText: trimmedContent)
        let newMessage = MessageModel(
            content: trimmedContent,
            date: Date(),
            isFlagged: scanResult != nil,
            sender: sender,
            receiver: receiver
        )
        
        context.insert(newMessage)
        
        
        if let result = scanResult {
            let alertMessage = scanner.scamAlertMessagesMap[result.scamType] ??  "This message appears to be a \(result.scamType.replacingOccurrences(of: "_", with: " "))."
            
            newMessage.scamAlertMessage = alertMessage
            
            let alert = ScamAlertModel(
                scamType: result.scamType,
                severity: result.severity,
                matchedKeywords: result.matchedKeywords,
                alertMessage: alertMessage,
                message: newMessage
            )
            context.insert(alert)
        }
        
        do {
            try context.save()
        } catch {
            print("⚠️ Failed to save message: \(error.localizedDescription)")
        }
    }
}
