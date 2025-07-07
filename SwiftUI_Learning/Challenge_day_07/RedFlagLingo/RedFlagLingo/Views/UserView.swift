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
    @Query(sort: \MessageModel.date, order: .forward)
    private var allMessages: [MessageModel]

    
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
 
    var conversationPartners: [UserModel] {
        let sentToUsers = Set(user.sentMessages.compactMap { $0.receiver })
        let receivedFromUsers = Set(user.receivedMessages.compactMap { $0.sender })
        return Array(sentToUsers.union(receivedFromUsers))
    }
    

    var body: some View {
        ZStack {
            
            
            Color(hex: "#90a1b9")
                .ignoresSafeArea()
            
            VStack{
                Text("Welcome, \(user.username)")
                    .font(.title)
                    .foregroundColor(.white)
                
                List{
                    Section(header: Text("Conversations")) {
                        ForEach(conversationPartners) { partner in
                            NavigationLink {
                                MessageView(currentUser: user, chatPartner:partner)
                            } label: {
                                let lastMessage = allMessages
                                    .filter {
                                        ($0.sender?.id == user.id && $0.receiver?.id == partner.id) ||
                                        ($0.sender?.id == partner.id && $0.receiver?.id == user.id)
                                    }
                                    .sorted { $0.date < $1.date }
                                    .last
                                
                                
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
                .scrollContentBackground(.hidden)
                .background(Color(hex: "#90a1b9"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .listRowBackground(Color(hex: "#2c313a"))
                
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
                        .frame(maxWidth:.infinity, alignment: .bottomTrailing)
                    }
                }
                .padding(.bottom, 20)
                .scrollContentBackground(.hidden)
                .background(Color(hex: "#90a1b9"))
                
            }
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
