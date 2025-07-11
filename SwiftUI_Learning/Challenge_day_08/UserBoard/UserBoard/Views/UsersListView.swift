//
//  UsersListView.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import SwiftUI

struct UsersListView: View {
    @State var authVM: SupabaseAuthViewModel
    
    @State private var publicUserVM = PublicUserViewModel()
    
    var body: some View {
        VStack{
            
            if publicUserVM.isLoading {
                ProgressView()
            } else if let error = publicUserVM.errorMessage {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
            }
            else{
                List(publicUserVM.users){user in
                    HStack(alignment: .center) {
                        Text(user.username)
                            .font(.headline)
                        Spacer()
                        Text(user.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
        }
        .navigationTitle("Welcome, \(authVM.currentUser?.username ?? "Unknown")!")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("Logout") {
                    Task {
                        await authVM.logout()
                    }
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
        .task{
            await publicUserVM.fetchRecentUsers()
        }
    }
}

#Preview {
    NavigationView {
        UsersListView(authVM: SupabaseAuthViewModel())
    }
}
