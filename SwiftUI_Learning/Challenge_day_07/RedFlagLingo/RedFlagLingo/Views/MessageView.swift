//
//  MessageView.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import SwiftUI
import SwiftData

struct MessageView: View {
    @Environment(\.modelContext) var modelContext
    
    let currentUser: UserModel
    let chatPartner: UserModel
    
    // Use @Query to auto-update when modelContext changes
    @Query(sort: \MessageModel.date, order: .forward) private var allMessages: [MessageModel]
    
    // Filter messages related to the conversation
    var messages: [MessageModel] {
        allMessages.filter { message in
            (message.sender?.id == currentUser.id && message.receiver?.id == chatPartner.id) ||
            (message.sender?.id == chatPartner.id && message.receiver?.id == currentUser.id)
        }
    }
    
    
    
    
    var nonFlaggedMessages: [MessageModel] {
        messages.filter { !$0.isFlagged }.sorted(by: { $0.date < $1.date })
    }
    
    var flaggedMessages: [MessageModel] {
        messages.filter { $0.isFlagged }.sorted(by: { $0.date < $1.date })
    }
    
    
    func deleteNonScamMessages(at offsets: IndexSet){
        for index in offsets {
            let message = messages.sorted(by: {$0.date < $1.date})[index]
            // find non flagged messages in our query
            if message.isFlagged == false {
                modelContext.delete(message)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("⚠️ Failed to delete message: \(error.localizedDescription)")
        }
    }
    
    
    
    var body: some View {
        ZStack {
            Color(hex: "#90a1b9")
                .ignoresSafeArea()
            
            List{
                Section("Safe Messages"){
                    ForEach(nonFlaggedMessages) {message in
                        MessageRowView(message: message)
                    }
                    .onDelete(perform: deleteNonScamMessages)
                    
                }
                
                
                Section("Flagged Messages"){
                    ForEach(flaggedMessages) {message in
                        MessageRowView(message: message)
                    }
                    
                }
            }
            .navigationTitle(chatPartner.username)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
}

#Preview {
    let container = try! ModelContainer(
        for: UserModel.self, MessageModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    let user = UserModel(username: "TestUser")
    let partner = UserModel(username: "ChatPartner")
    context.insert(user)
    context.insert(partner)
    
    let safeMessage = MessageModel(
        content: "Hello safe message",
        date: Date().addingTimeInterval(-3600),
        isFlagged: false,
        sender: user,
        receiver: partner
    )
    let flaggedMessage = MessageModel(
        content: "Scam message",
        date: Date(),
        isFlagged: true,
        sender: partner,
        receiver: user,
        scamAlertMessage: "This message appears to be a phishing scam."
    )
    context.insert(safeMessage)
    context.insert(flaggedMessage)
    
    try? context.save()
    
    return NavigationView {
        MessageView(currentUser: user, chatPartner: partner)
            .modelContainer(container) // <-- Move this here
    }
}
