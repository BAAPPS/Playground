//
//  UsersListView.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import SwiftUI
import SwiftData

struct UsersListView: View {
    @Bindable var authVM: SupabaseAuthViewModel
    
    @State private var publicUserVM = PublicUserViewModel()
    
    @State private var networkMonitor = NetworkMonitorModel()
    
    @State private var showingEditProfile = false
    
    @Environment(\.modelContext) private var modelContext
    
    
    @Query(filter: #Predicate<UserProfile> { $0.username != "" },
           sort: \UserProfile.created_at,
           order: .reverse)
    var cachedUsers: [UserProfile]
    
    
    var body: some View {
        VStack{
            if publicUserVM.isLoading {
                ProgressView()
            } else if let error = publicUserVM.errorMessage {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
            }
            else{
                ScrollView {
                    LazyVStack(alignment:.leading, spacing: 12) {
                        Text("Welcome, \(authVM.currentUser?.username ?? "Unknown")!")
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity, alignment: .center)
                        
                        if !networkMonitor.isConnected {
                            Text("You're in offline mode")
                                .font(.caption)
                                .foregroundColor(.yellow)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 5)
                        }
                        
                        
                        if networkMonitor.isConnected {
                            UserListRowView(users: publicUserVM.users)
                        } else{
                            UserListRowView(users:cachedUsers)
                        }
                    }
                }
                .background(Color.black.opacity(0.6))
            }
            
        }
        .navigationTitle("New Users")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    Task {
                        await authVM.logout()
                    }
                } label: {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 25, weight: .bold))
                }
                .buttonStyle(.bordered)
                .padding()
            }
            ToolbarItem(placement: .topBarLeading){
                Button{
                    showingEditProfile = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 25, weight: .bold))
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
        .task {
            if networkMonitor.isConnected {
                await publicUserVM.fetchRecentUsers(context: modelContext)
            } else {
                print("📴 Offline mode — using cached data")
            }
        }
        
        .sheet(isPresented: $showingEditProfile) {
            ZStack {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProfileEditView(authVM: authVM, showEditProfile: $showingEditProfile)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .userDidUpdate, object: nil, queue: .main) { _ in
                Task { @MainActor in
                    await publicUserVM.fetchRecentUsers(context: modelContext)
                }
            }
        }

        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .userDidUpdate, object: nil)
        }
        
        
    }
}

#Preview {
    NavigationView {
        UsersListView(authVM: SupabaseAuthViewModel())
    }
}
