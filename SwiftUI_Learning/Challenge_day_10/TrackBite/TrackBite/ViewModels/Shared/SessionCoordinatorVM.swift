//
//  SessionCoordinatorVM.swift
//  TrackBite
//
//  Created by D F on 7/30/25.
//

import Foundation
import Observation

@Observable
class SessionCoordinatorVM {
  
    @MainActor
    func loadUserDataAfterLogin(role: UserRole) async {
        switch role {
        case .restaurant:
            await RestaurantVM.shared.fetchAllRestaurantsForCurrentUser()
        case .driver:
            break
        case .customer:
            break
            
        }
    }
    
}
