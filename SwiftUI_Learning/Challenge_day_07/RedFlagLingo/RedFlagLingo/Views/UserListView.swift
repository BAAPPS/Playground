//
//  UserListView.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import SwiftUI
import SwiftData

struct UserListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var users: [UserModel] = []
    let scanner = ScamScannerViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(users) { user in
                    NavigationLink {
                        UserView(user: user,
                                 userVM: UserViewModel(context: modelContext),
                                 messageVM: MessageViewModel(context: modelContext,
                                                             scanner: scanner,
                                                             users: users))
                    } label: {
                        Text(user.username)
                    }
                }
            }
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            // Only insert users if empty to avoid duplicates
            if (try? modelContext.fetch(FetchDescriptor<UserModel>()).isEmpty) ?? true {
                let addUsers = ["Angel", "Bobbie", "Rob", "Tim", "Durkin"]
                for name in addUsers {
                    let newUser = UserModel(username: name)
                    modelContext.insert(newUser)
                }
                try? modelContext.save()
            }
            // Load users from persistence into the @State array
            users = (try? modelContext.fetch(FetchDescriptor<UserModel>())) ?? []
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: UserModel.self)
    
    return NavigationView {
        UserListView()
            .modelContainer(container)
    }
}
