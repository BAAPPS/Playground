//
//  RestaurantOwnerSnapshotVM.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation
import Observation

@Observable
class RestaurantOwnerSnapshotVM {
    var isLoading = false
    var errorMessage: String?
    let localSaver = SaveDataLocallyVM<RestaurantOwnerSnapshotModel>(fileName: "restaurant_owner_snapshots.json")
    
    static let shared = RestaurantOwnerSnapshotVM(
        snapshotModel: RestaurantOwnerSnapshotModel(
            id: UUID(),
            userId: UUID(),
            userName: "",
            userEmail: "",
            restaurantId: UUID(),
            restaurantName: "",
            snapshotCreatedAt: Date(),
            description: "",
            imageURL: "",
            address: "",
            phone: ""
        )
    )

    private let client = SupabaseManager.shared.client
    var restaurantSnapshotModel: RestaurantOwnerSnapshotModel
    var restaurantsWithOwnerInfoTable = TableName.restaurant_owner_snapshots
    var allUserRestaurants: [RestaurantOwnerSnapshotModel] = []
    
    var groupedByUser: [String: [RestaurantOwnerSnapshotModel]] {
        Dictionary(grouping: allUserRestaurants) { $0.userName }
    }

    
    init(snapshotModel: RestaurantOwnerSnapshotModel){
        self.restaurantSnapshotModel = snapshotModel
    }

    
    @MainActor
    func fetchAllRestaurantsSnapshotsFromAllUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let allRestaurantsFromAllUsers: [RestaurantOwnerSnapshotModel] = try await client
                .from("\(restaurantsWithOwnerInfoTable)")
                .select("*")
                .execute()
                .value
            
            self.allUserRestaurants = allRestaurantsFromAllUsers
            
            // Save locally after fetching
            try localSaver.saveLocally(allRestaurantsFromAllUsers)
            
            print("All restaurants info:, \(self.allUserRestaurants)")
            print("✅ Restaurants saved locally after fetch.")
            
        }catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func loadRestaurantsSnapshotsFromLocal() {
        do {
            let savedRestaurants = try localSaver.loadLocally()
            self.allUserRestaurants = savedRestaurants
            print("✅ Loaded restaurants from local storage")
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
