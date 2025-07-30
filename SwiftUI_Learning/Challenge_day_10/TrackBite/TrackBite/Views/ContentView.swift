//
//  ContentView.swift
//  TrackBite
//
//  Created by D F on 7/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(CustomerVM.self) var customerVM
    @Environment(RestaurantVM.self) var restaurantVM
    @Environment(SessionCoordinatorVM.self) var sessionCoordVM
    @Environment(\.modelContext) private var modelContext
    @State var authVM: SupabaseAuthVM
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Group {
                    if localAuthVM.currentUser != nil {
                        if !localAuthVM.hasCompletedOnboarding {
                            OnboardingView(userRole: localAuthVM.currentUser!.role)
                        } else {
                            LoggedInView(authVM: authVM)
                        }

                    } else {
                        AuthSwitcherView(authVM: authVM)
                    }
                }
            }
        }
        .onAppear {
            localAuthVM.modelContext = modelContext
            localAuthVM.debugPrintAllLocalUsers()
        }
    }
}

#Preview {
    let authVM = SupabaseAuthVM()
    let localAuthVM = LocalAuthVM.shared
    let sessionCoordVM = SessionCoordinatorVM()
    let customerVM = CustomerVM(customerModel: CustomerModel(
        id: UUID(),
        address: "123 Main St",
        phoneNumber: "555-1234",
        preferredPayment: "Credit Card",
        deletedAt: nil,
        createdAt: Date()
    ))
    
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
    ContentView(authVM: authVM)
        .environment(localAuthVM)
        .environment(customerVM)
        .environment(restaurantVM)
        .environment(sessionCoordVM)
}
