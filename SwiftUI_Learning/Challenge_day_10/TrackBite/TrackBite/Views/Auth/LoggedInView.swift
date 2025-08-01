//
//  LoggedInView.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import SwiftUI
import SwiftData

struct LoggedInView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantVM.self) var restaurantVM
    @Environment(SessionCoordinatorVM.self) var sessionCoordVM
    @Bindable var authVM: SupabaseAuthVM
    @State private var showSettings = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                RoleDestinationView()
                    .environment(localAuthVM)
                    .environment(restaurantVM)
            }
            .bodyBackground(color:.lightWhite)
            .navigationTitle("\(localAuthVM.currentUser?.name ?? "Unknown User")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    Button{
                        showSettings = true
                    }label:{
                        Image(systemName: "gear")
                            .foregroundColor(.offWhite)
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings){
                SettingDestinationView()
                    .environment(localAuthVM)
                    .environment(restaurantVM)
                    .environment(\.supabaseAuthVM, $authVM)
            }
            .task{
                if let role = localAuthVM.currentUser?.role {
                    await sessionCoordVM.loadUserDataAfterLogin(role: role)
                }
                
                await restaurantVM.fetchAllRestaurantsFromAllUsers()
            }
        }
    }
}

#Preview {
    let authVM = SupabaseAuthVM()
    let localAuthVM = LocalAuthVM.shared
    let sessionCoordVM = SessionCoordinatorVM()
    let restaurantVM = RestaurantVM(
       restaurantModel: RestaurantModel(
           id: UUID(),
           name: "",
           description: nil,
           imageURL: nil,
           address: "",
           latitude: 0.0,
           longitude: 0.0,
           phone: nil,
           website: nil,
           ownerID: UUID(),
           createdAt: Date()
       )
   )
    NavigationStack {
        LoggedInView(authVM: authVM)
            .environment(localAuthVM)
            .environment(restaurantVM)
            .environment(sessionCoordVM)
    }
}
