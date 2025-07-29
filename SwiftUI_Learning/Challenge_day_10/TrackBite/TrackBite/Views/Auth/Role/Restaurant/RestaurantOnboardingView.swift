//
//  RestaurantOnboardingView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct RestaurantOnboardingView: View {
    @Environment(RestaurantVM.self) var restaurantVME
    var body: some View {
        @Bindable var restaurantVM =  restaurantVME
        NavigationStack(path: $restaurantVM.onboardingPath){
            RestaurantStepView(step: .restaurantStoreInfo, onNext: {
                restaurantVM.onboardingPath.append(.restaurantLocationInfo)
            }).navigationDestination(for: RestaurantOnboardingStep.self) { step in
                RestaurantStepView(step: step, onNext: {
                    restaurantVM.advanceToNextStep(from: step)
                })
            }
            
        }
        .bodyBackground()
    }
}

#Preview {
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
    RestaurantOnboardingView()
        .environment(restaurantVM)
}
