//
//  TrackBiteApp.swift
//  TrackBite
//
//  Created by D F on 7/23/25.
//

import SwiftUI
import SwiftData

@main
struct TrackBiteApp: App {
    @State private var authVM = SupabaseAuthVM()
    @State private var localAuthVM = LocalAuthVM.shared
    @State private var restaurantVM = RestaurantVM.shared
    @State private var networkVM = NetworkMonitorVM()
    @State private var sessionCoordVM = SessionCoordinatorVM()
    
    @State private var customerVM = CustomerVM(
        customerModel: CustomerModel(
            id: UUID(),
            address: "123 Main St",
            phoneNumber: "555-1234",
            preferredPayment: "Credit Card",
            deletedAt: nil,
            createdAt: Date()
        )
    )
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(authVM: authVM)
                .environment(localAuthVM)
                .environment(customerVM)
                .environment(restaurantVM)
                .environment(sessionCoordVM)
                .task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
                    
                    if networkVM.networkMonitor.isConnected {
                        await networkVM.restoreSession()
                    } else {
                        print("🚫 Skipping restoreSession — no internet")
                        localAuthVM.loadCachedUserFromID()
                    }
                }

                .onAppear {
                    print("💾 App launched: hasCompletedOnboarding = \(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"))")
                    
                    guard let userIDString = localAuthVM.currentUser?.id,
                          let userUUID = UUID(uuidString: userIDString) else {
                        print("❌ .onAppear: No valid current user ID")
                        return
                    }
                    
                    print("✅ .onAppear: Got user UUID:", userUUID)
                    
                    // Update Customer VM only if user role is customer
                    if localAuthVM.currentUser?.role == .customer {
                        customerVM.customerModel = CustomerModel(
                            id: userUUID,
                            address: "",
                            phoneNumber: "",
                            preferredPayment: "",
                            deletedAt: nil,
                            createdAt: Date()
                        )
                    }
                    
                    // Update Restaurant VM only if user role is restaurant
                    if localAuthVM.currentUser?.role == .restaurant {
                        restaurantVM.restaurantModel = RestaurantModel(
                            id: UUID(),
                            name: "",
                            description: nil,
                            imageURL: nil,
                            address: "",
                            latitude: 0.0,
                            longitude: 0.0,
                            phone: nil,
                            website: nil,
                            ownerID: userUUID,
                            createdAt: Date()
                        )
                    }
                }
                .onChange(of: localAuthVM.currentUser?.id) { oldID, newID in
                    guard let idString = newID,
                          let uuid = UUID(uuidString: idString) else {
                        print("❌ .onChange: Invalid or missing user ID")
                        return
                    }
                    
                    print("✅ .onChange: Got user UUID:", uuid)
                    
                    if localAuthVM.currentUser?.role == .customer {
                        customerVM.customerModel = CustomerModel(
                            id: uuid,
                            address: "",
                            phoneNumber: "",
                            preferredPayment: "",
                            deletedAt: nil,
                            createdAt: Date()
                        )
                    }
                    
                    if localAuthVM.currentUser?.role == .restaurant {
                        restaurantVM.restaurantModel = RestaurantModel(
                            id: UUID(),
                            name: "",
                            description: nil,
                            imageURL: nil,
                            address: "",
                            latitude: 0.0,
                            longitude: 0.0,
                            phone: nil,
                            website: nil,
                            ownerID: uuid,
                            createdAt: Date()
                        )
                    }
                }
        }
        .modelContainer(for: LocalUser.self)
    }
}
