//
//  UserView.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @Environment(\.modelContext) var modelContext
    
    @Bindable var user: UserModel
    
    
    @State var userVM: UserViewModel
    @State var messageVM: MessageViewModel
    
    @State private var message = ""
    @State private var selectedRecipient: UserModel?
    
    
    private func sendMessage() {
        guard let recipient = selectedRecipient else { return }
        messageVM.sendMessage(from: user.id, to: recipient.id, content: message)
        message = ""
        
        userVM.loadUsers()
        
        // Update this view's user with the fresh instance
        if let updatedUser = userVM.users.first(where: { $0.id == user.id }) {
            user.sentMessages = updatedUser.sentMessages
            user.receivedMessages = updatedUser.receivedMessages
        }
    }
    
    func chatMessages(with otherUser: UserModel?) -> [MessageModel] {
        guard let otherUser else { return [] }
        
        let userId = user.id
        let otherUserId = otherUser.id
        
        let fetch = FetchDescriptor<MessageModel>(
            predicate: #Predicate { message in
                ((message.sender?.id == userId) && (message.receiver?.id == otherUserId)) ||
                ((message.sender?.id == otherUserId) && (message.receiver?.id == userId))
            },
            sortBy: [SortDescriptor(\.date)]
        )
        
        
        do {
            return try modelContext.fetch(fetch)
        } catch {
            print("⚠️ Failed to fetch chat messages: \(error.localizedDescription)")
            return []
        }
    }
    
    var conversationPartners: [UserModel] {
        let sentToUsers = Set(user.sentMessages.compactMap { $0.receiver })
        let receivedFromUsers = Set(user.receivedMessages.compactMap { $0.sender })
        return Array(sentToUsers.union(receivedFromUsers))
    }
    
    
    
    var body: some View {
        VStack{
            Text("Welcome, \(user.username)")
                .font(.title)
            
            List{
                Section(header: Text("Conversations")) {
                    ForEach(conversationPartners) { partner in
                        NavigationLink {
                            MessageView(messages: chatMessages(with: partner))
                        } label: {
                            let messages = chatMessages(with: partner)
                            let lastMessage = messages.last
                            
                            HStack {
                                Text(partner.username)
                                    .font(.headline)
                                Spacer()
                                Text(lastMessage?.content ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(lastMessage?.isFlagged == true ? .red : .secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                
            }
            
            Form{
                Section("Send to") {
                    Picker("Recipient", selection: $selectedRecipient){
                        ForEach(userVM.users.filter{$0.id != user.id}) {otherUser in
                            Text(otherUser.username).tag(otherUser as UserModel?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section {
                    TextField("Write a message",text:$message)
                        .textInputAutocapitalization(.never)
                        .padding()
                    Button("Send"){
                        sendMessage()
                    }
                }
            }
            .padding(.bottom, 20)
            
        }
        
    }
}

#Preview {
    let container = try! ModelContainer(for: UserModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    // Create mock users
    let tim = UserModel(username: "TimDurkn")
    let bob = UserModel(username: "Bobbie")
    
    context.insert(tim)
    context.insert(bob)
    
    let userVM = UserViewModel(context: context)
    
    // Initialize your scanner (customize if needed)
    let scanner = ScamScannerViewModel()
    
    // Initialize MessageViewModel with users loaded from userVM
    let messageVM = MessageViewModel(context: context, scanner: scanner, users: userVM.users)
    
    
    
    return NavigationView {
        UserView(user: tim, userVM: userVM, messageVM: messageVM)
            .modelContainer(container)
    }
}
