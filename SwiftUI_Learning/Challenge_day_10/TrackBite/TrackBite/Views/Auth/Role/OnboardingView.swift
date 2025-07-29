//
//  OnboardingView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(CustomerVM.self) var customerVM
    @Environment(RestaurantVM.self) var restaurantVM
    let userRole: UserRole

    var body: some View {
        switch userRole {
        case .driver:
            DriverOnboardingView()
        case .customer:
            CustomerOnboardingView()
        case .restaurant:
            RestaurantOnboardingView()
        }
    }
}

#Preview {
    
    let localAuthVM = LocalAuthVM.shared
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
    OnboardingView(userRole: UserRole.customer)
        .environment(localAuthVM)
        .environment(customerVM)
        .environment(restaurantVM)
}
